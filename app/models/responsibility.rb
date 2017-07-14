class Responsibility < ActiveRecord::Base
  include RankedModel
  include CanArchive

  ranks :sort_order

  scope :ordered, -> { rank(:sort_order) }

  validates :title, :adjective, presence: true,
    uniqueness: {
      allow_blank: true,
      scope: :active,
      if: :active?
    }
  validates :harvest_client_ids, presence: true, unless: :default?
  validate :only_one_default_may_exist, if: [:default?, :default_changed?]

  before_save :clear_harvest_client_ids, if: :default?

  def self.reorder(id, position)
    find(id).update!(sort_order_position: position)
  end

  def self.for_harvest_client_id(harvest_client_id, responsibilities = active.ordered.to_a)
    responsibilities
      .detect { |r| r.harvest_client_ids.include?(harvest_client_id.to_s) } ||
    responsibilities.detect(&:default?)
  end

  def harvest_client_ids=(values)
    if values.is_a?(Array)
      super(values.reject(&:blank?).map(&:to_s).uniq)
    else
      super
    end
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
