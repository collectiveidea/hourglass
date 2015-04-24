class Day < ActiveRecord::Base
  belongs_to :user, inverse_of: :days, required: true

  validates :date, presence: true, date: true, uniqueness: { scope: :user_id }

  def self.ensure(user:, date:, **attributes)
    find_or_initialize_by(user: user, date: date).update!(attributes)
  end

  def self.last_week
    where(date: 1.week.ago.to_date.all_week).order(:date)
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
end
