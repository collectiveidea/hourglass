class FetchDailyHours
  include Interactor
  include HasHarvest

  before do
    context.date ||= Date.current
  end

  def call
    User.active.each do |user|
      harvest_time_entries = harvest.time.all(context.date, user.harvest_id)
      hours, tracked_in_real_time = {}, false

      harvest_time_entries.each do |entry|
        if responsibility = responsibility_for_harvest_time_entry(entry)
          hours[responsibility.id] ||= 0
          hours[responsibility.id] =
            (hours[responsibility.id].to_d + entry.hours.to_d).to_f

          tracked_in_real_time ||= in_progress?(entry)
        end
      end

      attributes = { user: user, date: context.date, hours: hours }
      attributes[:tracked_in_real_time] = true if tracked_in_real_time

      Day.ensure(attributes)
    end
  end

  private

  def responsibility_for_harvest_time_entry(harvest_time_entry)
    harvest_project = harvest_projects.detect do |project|
      project.id.to_s == harvest_time_entry.project_id.to_s
    end
    harvest_client_id = harvest_project.client_id
    Responsibility.for_harvest_client_id(harvest_client_id, responsibilities)
  end

  def harvest_projects
    @harvest_projects ||= harvest.projects.all
  end

  def responsibilities
    @responsibilities ||= Responsibility.active.ordered.to_a
  end

  def in_progress?(harvest_time_entry)
    harvest_time_entry.hours > harvest_time_entry.hours_without_timer
  end
end
