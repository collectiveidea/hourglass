class Month < ActiveRecord::Base
  belongs_to :user, inverse_of: :months, required: true

  validates :number, presence: true, uniqueness: { scope: :user_id },
    format: { with: /\A\d{6}\z/ }

  def self.roll_up(user: nil, number: 2.months.ago.strftime("%Y%m"))
    if user
      unless where(user: user, number: number).exists?
        days = Day.where(user: user, month_number: number)

        if days.any?
          client_hours = days.sum(:client_hours)
          internal_hours = days.sum(:internal_hours)

          create!(
            user: user,
            number: number,
            client_hours: client_hours,
            internal_hours: internal_hours
          )

          days.delete_all
        end
      end
    else
      User.all.each { |u| roll_up(user: u, number: number) }
    end
  end
end
