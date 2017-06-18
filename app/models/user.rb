class User < ActiveRecord::Base
  has_many :days, -> { order(:date) }, inverse_of: :user,
    dependent: :restrict_with_exception
  has_many :months, -> { order(:year, :number) }, inverse_of: :user,
    dependent: :restrict_with_exception

  validates :name, presence: true
  validates :email, presence: true, email: true,
    uniqueness: { case_sensitive: false, scope: :active, if: :active? }
  validates :harvest_id, :zenefits_name, :slack_id, presence: true,
    uniqueness: true
  validates :time_zone, presence: true,
    inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }

  delegate :client_hours_for_date_range, :internal_hours_for_date_range,
    :pto_hours_for_date_range, to: :days

  scope :active, -> { where(active: true) }
  scope :with_tags, -> (tags) { where("tags @> ARRAY[?]", tags) }

  def self.for_timer_reminder(date: Date.current)
    joins(:days).merge(Day.for_timer_reminder(date: date))
  end

  def self.time_zones
    pluck("DISTINCT time_zone")
  end

  def self.tags
    order("tag ASC").pluck("DISTINCT UNNEST(tags) AS tag")
  end

  def timer_reminder_sent!(date: Date.current)
    days.find_by!(date: date).update!(timer_reminder_sent: true)
  end

  def works_on?(date:)
    workdays.include?(date.cwday.to_s)
  end

  def workdays=(values)
    super(values.reject(&:blank?))
  end

  def archive
    update!(active: false)
  end

  def tags=(values)
    super(values.reject(&:blank?))
  end
end
