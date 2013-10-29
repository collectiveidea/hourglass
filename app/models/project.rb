class Project < ActiveRecord::Base
  has_many :days do
    def current_week
      today = Date.current
      where(date: today.beginning_of_week..today.end_of_week)
    end
  end

  validates :name, :harvest_id, presence: true
  validates :harvest_id, uniqueness: true
  validates :guaranteed_weekly_hours, numericality: { greater_than: 0, only_integer: true }

  def current_weekly_hours
    @current_weekly_hours ||= days.current_week.sum(:hours)
  end

  def weekly_hours_met
    current_weekly_hours >= guaranteed_weekly_hours
  end
end
