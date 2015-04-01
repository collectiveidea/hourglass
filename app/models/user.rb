class User < ActiveRecord::Base
  has_many :days, inverse_of: :user, dependent: :restrict_with_exception
  has_many :months, inverse_of: :user, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :harvest_id, :zenefits_name, presence: true, uniqueness: true
  validates :time_zone, presence: true,
    inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }
end
