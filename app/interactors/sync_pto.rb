class SyncPTO
  include Interactor

  def call
    events.each do |event|
      dates = dates_for_event(event)

      if holiday?(event)
        users.each do |user|
          dates.each do |date|
            Day.ensure(user: user, date: date, pto: true)
          end
        end
      elsif user = user_for_personal_event(event)
        dates.each do |date|
          Day.ensure(user: user, date: date, pto: true)
        end
      end
    end
  end

  private

  def events
    Icalendar.parse(open(ENV["ZENEFITS_PTO_CALENDAR_URL"])).first.events
  end

  def dates_for_event(event)
    (event.dtstart.to_date...event.dtend.to_date).to_a
  end

  def holiday?(event)
    event.description == "Holiday"
  end

  def user_for_personal_event(event)
    zenefits_name = event.summary.split(":", 2)[-2]
    users.detect { |u| u.zenefits_name == zenefits_name }
  end

  def users
    @users ||= User.all
  end
end
