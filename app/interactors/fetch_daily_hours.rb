class FetchDailyHours
  include Interactor
  include HasHarvest

  before do
    context.date ||= Date.current
  end

  def call
    User.all.each do |user|
      time_entries = harvest.time.all(context.date, user.harvest_id)
      client_hours, internal_hours = 0, 0

      time_entries.each do |time_entry|
        if internal?(time_entry)
          internal_hours += time_entry.hours.to_d
        else
          client_hours += time_entry.hours.to_d
        end
      end

      Day.ensure(
        user: user,
        date: context.date,
        client_hours: client_hours,
        internal_hours: internal_hours
      )
    end
  end

  private

  def internal?(time_entry)
    time_entry.client == ENV["HARVEST_INTERNAL_CLIENT"]
  end
end
