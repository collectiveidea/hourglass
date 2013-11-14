class Day < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :date, presence: true, strict: true
  validates :date, uniqueness: { scope: :project_id }, strict: true
  validates :hours, numericality: { greater_than_or_equal_to: 0 }, strict: true

  def self.save_for_date(date, hours)
    day = find_or_initialize_by(date: date)
    day.hours = hours
    day.save!
  end
end
