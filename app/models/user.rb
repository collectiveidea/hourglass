class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :harvest_id, :zenefits_name, presence: true, uniqueness: true
  validates :time_zone, presence: true,
    inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }
end
