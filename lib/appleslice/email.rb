module AppleSlice
  class Email
    ITUNES_URL_FORMAT = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%s&mt=8"

    STATUS_CONTENT_TO_STATUS = {
      "The status for the following app has changed to Waiting For Upload.".downcase => :waiting_for_upload,
      "The status for the following app has changed to Waiting For Review.".downcase => :waiting_for_review,
      "The status for the following app has changed to In Review.".downcase => :in_review,
      "The status for the following app has changed to Processing for App Store.".downcase => :processing_for_app_store,
      "The following app has been approved and the app status has changed to Ready for Sale:".downcase => :ready_for_sale,
      "The status for the following app has changed to Developer Rejected.".downcase => :developer_rejected,
      "The status for the following app has changed to Developer Removed From Sale.".downcase => :developer_removed_from_sale
    }

    attr_reader :body
    attr_accessor :id

    class UnknownEmailTypeError < StandardError; end
    class BadDataError < StandardError; end

    def initialize(body)
      @body = body
      @noko = Nokogiri::HTML.fragment(@body)
    end

    def review_status
      if @body.include?('we are unable to post this version.')
        return :rejected
      end

      status_content = @noko.search('p').first.content.downcase
      status = STATUS_CONTENT_TO_STATUS[status_content]
      status || begin
        message = "Unknown email type - content: #{status_content}"
        message = "Unknown email type - content: #{status_content} - id: #{self.id}" if self.id
        raise UnknownEmailTypeError, message
      end
    end

    def itunes_url
      ITUNES_URL_FORMAT % app_apple_id
    end

    def app_sku
      return nil if rejected?
      find_td('App SKU: ')
    end

    def app_version_number
      return nil if rejected?
      find_td('App Version Number: ')
    end

    def app_name
      if rejected?
        letter = @noko.css('#rejectionEmail p')[1]
        letter.content.split("Your app ")[-1].split(' has been reviewed')[0]
      else
        find_td('App Name: ').strip
      end
    end

    def app_apple_id
      if rejected?
        params = URI.parse(resolution_center_url).query
        CGI::parse(params)['adamId'].first
      else
        find_td('App Apple ID:')
      end
    end

    def resolution_center_url
      return nil unless rejected?
      @noko.css('#rejectionEmail a').first[:href]
    end

    def rejected?
      review_status == :rejected
    end

    def scheduled_maintenance?
      @body.include?("will undergo scheduled maintenance on ")
    end

    private
      def find_td(prefix)
        matches = @noko.search('td').select { |n|
          n.content.start_with?(prefix)
        }
        raise BadDataError, "Multiple matches for TD prefix #{prefix}" if matches.count > 1
        match = matches.first
        match.content.split(prefix)[-1]
      end
  end
end