class Responsibility < ActiveRecord::Base
  include RankedModel

  ranks :sort_order

  scope :ordered, -> { rank(:sort_order) }

  validates :title, :adjective, presence: true,
    uniqueness: { allow_blank: true }
  validates :harvest_client_ids, presence: true, unless: :default?
  validate :only_one_default_may_exist, if: [:default?, :default_changed?]

  before_save :clear_harvest_client_ids, if: :default?

  def self.reorder(id, position)
    find(id).update!(sort_order_position: position)
  end

  def harvest_client_ids=(values)
    super(values.reject(&:blank?))
  end

  private

  def only_one_default_may_exist
    if Responsibility.where(default: true).where.not(id: id).exists?
      errors.add(:base, :multiple_defaults)
    end
  end

  def clear_harvest_client_ids
    self.harvest_client_ids = []
  end
end
