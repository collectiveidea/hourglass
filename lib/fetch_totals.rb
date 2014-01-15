class FetchTotals < Struct.new(:date)
  def self.perform(date)
    new(date).perform
  end

  def perform
    billable_hours = unbillable_hours = 0.0
    harvest.projects.all.select{|p| p.active? }.each do |project|
      hours = harvest.reports.time_by_project(project.id, date, date).sum(&:hours)
      if project.billable?
        billable_hours += hours
      else
        unbillable_hours += hours
      end
    end
    
    DateTotal.find_or_create_by(date: date).update!(
      billable_hours: billable_hours,
      unbillable_hours: unbillable_hours,
    )
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
