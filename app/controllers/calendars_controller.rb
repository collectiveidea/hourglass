class CalendarsController < ApplicationController
  before_filter do
    authenticate_or_request_with_http_basic do |username, _password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV["CALENDAR_PASSWORD"])
    end
  end

  def pto
    render text: Rails.cache.read("pto.ics"), content_type: "text/calendar"
  end
end
