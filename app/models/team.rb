class Team < ActiveRecord::Base
  validates :name, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 0 }

  has_many :assignments
  has_many :users, through: :assignments

  scope :active, -> { where(active: true) }

  accepts_nested_attributes_for :assignments, reject_if: -> (attr) { attr['user_id'].blank? }, allow_destroy: true

  def archive
    update!(active: false)
  end
end
