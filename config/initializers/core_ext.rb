Date.class_eval do
  def self.this_week
    current.all_week
  end

  def self.last_week
    current.prev_week.all_week
  end

  def self.this_month
    current.all_month
  end

  def self.last_month
    current.prev_month.all_month
  end

  # Convenience methods to fetch the last occurence of the given weekday,
  # excluding today.
  class << self
    %i[
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
      sunday
    ].each do |weekday|
      define_method weekday do
        yesterday.beginning_of_week(weekday)
      end
    end
  end
end
