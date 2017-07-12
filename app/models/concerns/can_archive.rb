module CanArchive
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
  end

  module ClassMethods
    def archive(id)
      find(id).archive
    end

    def unarchive(id)
      find(id).unarchive
    end
  end

  def archive
    update!(active: false)
  end

  def unarchive
    update!(active: true)
  end
end
