class FetchDailyHours
  include Interactor
  include HasHarvest

  before do
    context.date ||= Date.current
  end

  def call
    User.active.each do |user|
      time_entries = harvest.time.all(context.date, user.harvest_id)
      client_hours, internal_hours, tracked_in_real_time = 0, 0, false

      time_entries.each do |time_entry|
        if internal?(time_entry)
          internal_hours += time_entry.hours.to_d
        else
          client_hours += time_entry.hours.to_d
        end

        tracked_in_real_time ||= in_progress?(time_entry)
      end

      attributes = {
        user: user,
        date: context.date,
        client_hours: client_hours,
        internal_hours: internal_hours
      }

      attributes[:tracked_in_real_time] = true if tracked_in_real_time

      Day.ensure(attributes)
    end
  end

  private

  def internal?(time_entry)
    time_entry.client == ENV["HARVEST_INTERNAL_CLIENT"]
  end

  def in_progress?(time_entry)
    time_entry.hours > time_entry.hours_without_timer
  end
end
