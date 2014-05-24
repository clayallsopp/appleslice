require 'spec_helper'

describe AppleSlice::Email do

  describe "#review_status" do
    it "should return :rejected if rejected" do
      body = email_data("rejected")
      AppleSlice::Email.new(body).review_status.should == :rejected
    end

    it "should return :ready_for_sale for that email" do
      body = email_data("ready_for_sale")
      AppleSlice::Email.new(body).review_status.should == :ready_for_sale
    end

    it "should return correct values" do
      [["Waiting For Upload", :waiting_for_upload],
       ["Waiting For Review", :waiting_for_review],
       ["In Review", :in_review],
       ["Processing for App Store", :processing_for_app_store],
       ["Developer Rejected", :developer_rejected],
       ["Developer Removed From Sale", :developer_removed_from_sale]
       ].each do |string, status|
        body = email_data("status_update", status_string: string)
        AppleSlice::Email.new(body).review_status.should == status
      end
    end
  end

  describe "#rejected?" do
    it "returns true if rejected" do
      body = email_data("rejected")
      AppleSlice::Email.new(body).rejected?.should == true
    end

    it "returns false if not rejected" do
      body = email_data("ready_for_sale")
      AppleSlice::Email.new(body).rejected?.should == false
      body = email_data("status_update")
      AppleSlice::Email.new(body).rejected?.should == false
    end
  end

  describe "#app_sku" do
    it "returns nil if rejected" do
      body = email_data("rejected")
      AppleSlice::Email.new(body).app_sku.should == nil
    end

    it "works for update emails" do
      body = email_data("status_update", app_sku: "SKU_1000")
      AppleSlice::Email.new(body).app_sku.should == "SKU_1000"
    end

    it "works for ready for sale emails" do
      body = email_data("ready_for_sale", app_sku: "SKU_1000")
      AppleSlice::Email.new(body).app_sku.should == "SKU_1000"
    end
  end

  describe "#app_version_number" do
    it "returns nil if rejected" do
      body = email_data("rejected")
      AppleSlice::Email.new(body).app_version_number.should == nil
    end

    it "works for update emails" do
      body = email_data("status_update", app_version_number: "1.0.5")
      AppleSlice::Email.new(body).app_version_number.should == "1.0.5"
    end

    it "works for ready for sale emails" do
      body = email_data("ready_for_sale", app_version_number: "1.1.0")
      AppleSlice::Email.new(body).app_version_number.should == "1.1.0"
    end
  end

  describe "#app_name" do
    it "works if rejected" do
      body = email_data("rejected", app_name: "APP_NAME")
      AppleSlice::Email.new(body).app_name.should == "APP_NAME"
    end

    it "works for update emails" do
      body = email_data("status_update", app_name: "APP_NAME")
      AppleSlice::Email.new(body).app_name.should == "APP_NAME"
    end

    it "works for ready for sale emails" do
      body = email_data("ready_for_sale", app_name: "APP_NAME")
      AppleSlice::Email.new(body).app_name.should == "APP_NAME"
    end
  end

  describe "#app_apple_id" do
    it "works if rejected" do
      body = email_data("rejected", app_name: "APP_NAME", app_apple_id: "REJECT_ID")
      AppleSlice::Email.new(body).app_apple_id.should == "REJECT_ID"
    end

    it "works for update emails" do
      body = email_data("status_update", app_apple_id: "APP_ID")
      AppleSlice::Email.new(body).app_apple_id.should == "APP_ID"
    end

    it "works for ready for sale emails" do
      body = email_data("ready_for_sale", app_apple_id: "APP_ID")
      AppleSlice::Email.new(body).app_apple_id.should == "APP_ID"
    end
  end

  describe "#resolution_center_url" do
    it "works if rejected" do
      url = "https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/da/rejectionReasons?adamId=herpderp"
      body = email_data("rejected", app_name: "APP_NAME", resolution_url: url)
      AppleSlice::Email.new(body).resolution_center_url.should == url
    end

    it "returns nil for update emails" do
      body = email_data("status_update")
      AppleSlice::Email.new(body).resolution_center_url.should == nil
    end

    it "returns nil for ready for sale emails" do
      body = email_data("ready_for_sale")
      AppleSlice::Email.new(body).resolution_center_url.should == nil
    end
  end

  describe "#itunes_url" do
    it "works if rejected" do
      body = email_data("rejected", app_name: "APP_NAME", app_apple_id: "REJECT_ID")
      AppleSlice::Email.new(body).itunes_url.should == (AppleSlice::Email::ITUNES_URL_FORMAT % "REJECT_ID")
    end

    it "works for update emails" do
      body = email_data("status_update", app_apple_id: "APP_ID")
      AppleSlice::Email.new(body).itunes_url.should == (AppleSlice::Email::ITUNES_URL_FORMAT % "APP_ID")
    end

    it "works for ready for sale emails" do
      body = email_data("ready_for_sale", app_apple_id: "APP_ID")
      AppleSlice::Email.new(body).itunes_url.should == (AppleSlice::Email::ITUNES_URL_FORMAT % "APP_ID")
    end
  end

  describe "#scheduled_maintenance?" do
    it "works for correct email" do
      body = email_data("maintenance")
      AppleSlice::Email.new(body).scheduled_maintenance?.should == true
    end

    it "returns false for other emails" do
      body = email_data("rejected")
      AppleSlice::Email.new(body).scheduled_maintenance?.should == false
      body = email_data("status_update")
      AppleSlice::Email.new(body).scheduled_maintenance?.should == false
      body = email_data("ready_for_sale")
      AppleSlice::Email.new(body).scheduled_maintenance?.should == false
    end
  end

end