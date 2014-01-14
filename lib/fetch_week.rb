class FetchWeek
  def self.perform
    new.perform
  end

  def perform
    week.each do |date|
      FetchDay.perform(date)
      FetchTotals.perform(date)
    end
  end

  private

  def week
    monday..today
  end

  def monday
    @monday ||= today.beginning_of_week
  end

  def today
    @today ||= Date.current
  end
end
