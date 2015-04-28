class Day < ActiveRecord::Base
  belongs_to :user, inverse_of: :days, required: true

  validates :date, presence: true, date: true, uniqueness: { scope: :user_id }

  def self.ensure(user:, date:, **attributes)
    find_or_initialize_by(user: user, date: date).update!(attributes)
  end

  def self.for_timer_reminder(date: Date.current)
    where(
      date: date,
      client_hours: 0,
      internal_hours: 0,
      pto: false,
      timer_reminder_sent: false
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

  def pto_hours
    pto? ? ENV["PTO_DAY_HOURS"].to_d : 0.to_d
  end
end
