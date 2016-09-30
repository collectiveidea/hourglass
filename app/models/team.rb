class Team < ActiveRecord::Base
  validates :name, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def archive
    update!(active: false)
  end
end
