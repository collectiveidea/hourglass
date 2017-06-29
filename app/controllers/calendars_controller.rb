class CalendarsController < ApplicationController
  def pto
    render text: Rails.cache.read("pto.ics"), content_type: "text/calendar"
  end

  private

  # This overrides basic authentication in ApplicationController.
  def authenticate
    authenticate_or_request_with_http_basic do |name, _|
      ActiveSupport::SecurityUtils.variable_size_secure_compare(name, ENV["CALENDAR_PASSWORD"])
    end
  end
end
