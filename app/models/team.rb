class Team < ActiveRecord::Base
  include HasHarvest

  validates :name, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 0 }

  has_many :assignments, -> { joins(:user).order("users.email") }
  has_many :users, through: :assignments

  before_save :set_harvest_project_name

  scope :active, -> { where(active: true) }

  accepts_nested_attributes_for :assignments, reject_if: -> (attr) { attr['user_id'].blank? }, allow_destroy: true

  def archive
    update!(active: false)
  end

  protected

  def set_harvest_project_name
    if self.project_id.present? && self.project_name.blank?
      self.project_name = harvest.projects.find(project_id).name
    end
  end
end
