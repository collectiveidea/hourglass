class SyncPTO
  include Interactor

  before do
    context.after ||= 1.month.ago.to_date
  end

  after do
    sanitize_and_cache_calendar
  end

  def call
    clear_future_pto

    events.each do |event|
      if holiday?(event)
        users.each do |user|
          ensure_pto_day(user: user, event: event)
        end
      elsif user = user_for_personal_event(event)
        ensure_pto_day(user: user, event: event)
      end
    end
  end

  private

  def clear_future_pto
    Day.clear_future
  end

  def calendar
    @calendar ||= begin
      source = open(ENV["ZENEFITS_PTO_CALENDAR_URL"])
      Icalendar::Calendar.parse(source)
    end
  end

  def events
    @events ||= calendar.first.events
  end

  def holiday?(event)
    event.uid.include?("holiday-item")
  end

  def user_for_personal_event(event)
    zenefits_name = event.summary.split(":", 2)[-2]
    users.detect { |u| u.zenefits_name == zenefits_name }
  end

  def users
    @users ||= User.active
  end

  def ensure_pto_day(user:, event:)
    dates_for_event(event).each do |date|
      next if date < context.after
      Day.ensure(user: user, date: date, pto: true)
    end
  end

  def dates_for_event(event)
    (event.dtstart.to_date...event.dtend.to_date).to_a
  end

  def sanitize_and_cache_calendar
    sanitized_calendar = Icalendar::Calendar.new
    sanitized_calendar.x_wr_calname = "Hourglass PTO"

    events.each do |event|
      sanitized_calendar.event do |sanitized_event|
        sanitized_event.summary = event.summary
        sanitized_event.dtstart = event.dtstart
        sanitized_event.dtend = event.dtend
      end
    end

    sanitized_calendar.publish

    Rails.cache.write("pto.ics", sanitized_calendar.to_ical)
  end
end
