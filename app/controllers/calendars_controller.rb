class CalendarsController < ApplicationController
  def pto
    render text: Rails.cache.read("pto.ics"), content_type: "text/calendar"
  end
end
