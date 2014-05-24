# AppleSlice - Parse iTunes Connect emails

Create an instance of `AppleSlice::Email` with your email's HTML body and slice away!

```ruby
require "appleslice"

email_body = "<!DOCTYPE HTML PUBLIC>..."

slice = AppleSlice::Email.new(email_body)

slice.review_status
# => :waiting_for_upload
slice.app_sku
# => "SKU_9000"
slice.app_version_number
# => "1.0.5"
slice.app_name
# => "Awesome App"
slice.app_apple_id
# => "98123921"
slice.itunes_url
# => http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=98123921&mt=8
```

## Installation

Add this line to your application's Gemfile:

    gem 'appleslice'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install AppleSlice

## Usage

The zeroth step to using AppleSlice is to get Apple emails into your Ruby system - you could use an email service like [Postmark](http://postmarkapp.com) or [Sendgrid](www.sendgrid.com) for that, or many other methods.

AppleSlice parses the following information for these types of emails:

#### Status Updates

- `#review_status`
- `#app_sku`
- `#app_version_number`
- `#app_name`
- `#app_apple_id`
- `#itunes_url`

#### Rejection

- `#review_status`
- `#app_name`
- `#app_apple_id`
- `#itunes_url`
- `#resolution_center_url`

#### All Emails

- `#rejected?`
- `#scheduled_maintenance?`

Valid values for `#review_status` are:

- `:waiting_for_upload`
- `:waiting_for_review`
- `:in_review`
- `:processing_for_app_store`
- `:ready_for_sale`
- `:developer_rejected`
- `:developer_removed_from_sale`
