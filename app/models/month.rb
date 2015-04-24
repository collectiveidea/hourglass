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
        days = Day.where(user: user, date: date_range)

        if days.any?
          client_hours = days.sum(:client_hours)
          internal_hours = days.sum(:internal_hours)

          create!(
            user: user,
            year: year,
            number: number,
            client_hours: client_hours,
            internal_hours: internal_hours
          )

          days.delete_all
        end
      end
    else
      User.all.each { |u| roll_up(user: u, year: year, number: number) }
    end
  end
end
