class FetchDailyHours
  include Interactor

  before do
    context.date ||= Date.current
    context.from ||= context.date
    context.to ||= context.date
    context.range ||= context.from..context.to
  end

  def call
    User.all.each do |user|
      context.range.each do |date|
        time_entries = harvest.time.all(date, user.harvest_id)
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
          date: date,
          client_hours: client_hours,
          internal_hours: internal_hours
        )
      end
    end
  end

  private

  def harvest
    @harvest ||= Harvest.hardy_client(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    )
  end

  def internal?(time_entry)
    time_entry.client == ENV["HARVEST_INTERNAL_CLIENT"]
  end
end
