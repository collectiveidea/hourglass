class Day < ActiveRecord::Base
  belongs_to :user, inverse_of: :days, required: true

  validates :date, presence: true, date: true, uniqueness: { scope: :user_id }
  validates :client_hours, :internal_hours, numericality: {
    greater_than_or_equal_to: 0,
    less_than: 100
  }

  scope :today, -> { where(date: Date.current) }
  scope :yesterday, -> { where(date: Date.yesterday) }
  scope :this_week, -> { where(date: Date.this_week) }
  scope :last_week, -> { where(date: Date.last_week) }
  scope :this_month, -> { where(date: Date.this_month) }
  scope :last_month, -> { where(date: Date.last_month) }
  scope :future, -> { where("date > ?", Date.current) }

  def self.ensure(user:, date:, **attributes)
    attributes[:workday] = user.works_on?(date: date)
    find_or_initialize_by(user: user, date: date).update!(attributes)
  end

  def self.for_timer_reminder(date: Date.current)
    where(
      date: date,
      client_hours: 0,
      internal_hours: 0,
      pto: false,
      timer_reminder_sent: false,
      workday: true
    )
  end

  def self.client_hours_for_date_range(date_range)
    where(date: date_range).sum(:client_hours)
  end

  def self.internal_hours_for_date_range(date_range)
    where(date: date_range).sum(:internal_hours)
  end

  def self.pto_hours_for_date_range(date_range)
    where(date: date_range, pto: true).count * ENV["PTO_DAY_HOURS"].to_d
  end

  def self.clear_future
    future.delete_all
  end

  def pto_hours
    pto? ? ENV["PTO_DAY_HOURS"].to_d : 0.to_d
  end
end
