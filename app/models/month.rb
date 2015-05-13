class Month < ActiveRecord::Base
  belongs_to :user, inverse_of: :months, required: true

  validates :year, presence: true,
    numericality: { only_integer: true, greater_than: 2000 }
  validates :number, presence: true, uniqueness: { scope: [:user_id, :year] },
    numericality: { only_integer: true, greater_than: 0, less_than: 13 }

  def self.roll_up(user: nil, year: 2.months.ago.year, number: 2.months.ago.month)
    if user
      unless where(user: user, number: number).exists?
        date_range = Date.new(year, number).all_month
        days = Day.where(user: user, date: date_range).to_a

        if days.any?
          client_hours = days.sum(&:client_hours)
          internal_hours = days.sum(&:internal_hours)
          day_count = days.count
          pto_count = days.count(&:pto?)
          timer_reminder_sent_count = days.count(&:timer_reminder_sent?)
          tracked_in_real_time_count = days.count(&:tracked_in_real_time?)

          create!(
            user: user,
            year: year,
            number: number,
            client_hours: client_hours,
            internal_hours: internal_hours,
            day_count: day_count,
            pto_count: pto_count,
            timer_reminder_sent_count: timer_reminder_sent_count,
            tracked_in_real_time_count: tracked_in_real_time_count
          )

          days.each(&:destroy)
        end
      end
    else
      User.all.each { |u| roll_up(user: u, year: year, number: number) }
    end
  end

  def pto_hours
    pto_hours * ENV["PTO_DAY_HOURS"].to_d
  end
end
