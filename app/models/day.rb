class Day < ActiveRecord::Base
  belongs_to :user, inverse_of: :days, required: true

  validates :date, presence: true, date: true, uniqueness: { scope: :user_id }

  before_create :set_month_number
  before_create :set_week_number

  def self.ensure(user:, date:, **attributes)
    find_or_initialize_by(user: user, date: date).update!(attributes)
  end

  def self.last_week
    where(week_number: 1.week.ago.strftime("%G%V")).order(:date)
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

  private

  def set_month_number
    self.month_number = date.strftime("%Y%m")
  end

  def set_week_number
    self.week_number = date.strftime("%G%V")
  end
end
