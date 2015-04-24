class User < ActiveRecord::Base
  has_many :days, -> { order(:date) }, inverse_of: :user,
    dependent: :restrict_with_exception
  has_many :months, -> { order(:year, :number) }, inverse_of: :user,
    dependent: :restrict_with_exception

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :harvest_id, :zenefits_name, :slack_id, presence: true,
    uniqueness: true
  validates :time_zone, presence: true,
    inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }

  def self.for_timer_reminder(date: Date.current)
    joins(:days).merge(Day.for_timer_reminder(date: date))
  end

  def client_hours_last_week
    days.last_week.sum(:client_hours)
  end

  def internal_hours_last_week
    days.last_week.sum(:internal_hours)
  end

  def client_hours_for_date_range(date_range)
    days.where(date: date_range).sum(:client_hours)
  end

  def internal_hours_for_date_range(date_range)
    days.where(date: date_range).sum(:internal_hours)
  end

  def timer_reminder_sent!(date: Date.current)
    days.find_by!(date: date).update!(timer_reminder_sent: true)
  end
end
