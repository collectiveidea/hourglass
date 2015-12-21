class SyncPTO
  include Interactor

  before do
    context.after ||= 1.month.ago.to_date
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

  def events
    Icalendar.parse(open(ENV["ZENEFITS_PTO_CALENDAR_URL"])).first.events
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
end
