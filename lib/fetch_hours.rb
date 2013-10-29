class FetchHours
  def self.perform
    new.perform
  end

  def perform
    Project.find_each do |project|
      reports = harvest.reports.time_by_project(project.id, range.min, range.max)
      project.days.save_for_date(now.to_date, reports.sum(&:hours))
    end
  end

  private

  def harvest
    @harvest ||= Harvest.client(
      ENV["HARVEST_SUBDOMAIN"],
      ENV["HARVEST_USERNAME"],
      ENV["HARVEST_PASSWORD"]
    )
  end

  def now
    @now ||= Time.current
  end

  def range
    @range ||= now.beginning_of_day..now.end_of_day
  end
end
