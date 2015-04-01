class Month < ActiveRecord::Base
  belongs_to :user, inverse_of: :months, required: true

  validates :number, presence: true, uniqueness: { scope: :user_id },
    format: { with: /\A\d{6}\z/ }
end
