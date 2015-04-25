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
end
