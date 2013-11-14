class FetchDay < Struct.new(:date)
  def self.perform(date)
    new(date).perform
  end

  def perform
    Project.find_each do |project|
      reports = harvest.reports.time_by_project(project.harvest_id, date, date)
      project.days.save_for_date(date, reports.sum(&:hours))
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
end
