class FetchHours
  def self.perform
    new.perform
  end

  def perform
    Project.find_each do |project|
      reports = harvest.reports.time_by_project(project.id, today, today)
      project.days.save_for_date(today, reports.sum(&:hours))
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

  def today
    @today ||= Date.current
  end
end
