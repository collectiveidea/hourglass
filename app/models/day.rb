class Day < ActiveRecord::Base
  belongs_to :user, inverse_of: :days, required: true

  validates :date, presence: true, date: true, uniqueness: { scope: :user_id }

  before_create :set_month_number
  before_create :set_week_number

  private

  def set_month_number
    self.month_number = date.strftime("%Y%m")
  end

  def set_week_number
    self.week_number = date.strftime("%G%V")
  end
end
