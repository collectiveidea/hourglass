class FetchWeek
  def self.perform
    new.perform
  end

  def perform
    week.each { |d| FetchDay.perform(d) }
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
