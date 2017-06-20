class Team < ActiveRecord::Base
  include HasHarvest

  validates :name, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 0 }

  has_many :assignments
  has_many :users, through: :assignments

  scope :active, -> { where(active: true) }

  accepts_nested_attributes_for :assignments, reject_if: -> (attr) { attr['user_id'].blank? }, allow_destroy: true

  def archive
    update!(active: false)
  end

  def update_project_name
    update!(project_name: harvest.projects.find(project_id).name)
  end
end
