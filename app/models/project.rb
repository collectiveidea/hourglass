class Project < ActiveRecord::Base
  validates :name, :harvest_id, presence: true
  validates :harvest_id, uniqueness: true
  validates :guaranteed_hours, numericality: { greater_than: 0, only_integer: true }
end
