class Offer < ApplicationRecord
  belongs_to :part
  belongs_to :store
  has_many :price_points, -> { order(:recorded_at) }, dependent: :destroy

  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :url, :checked_at, presence: true
  validates :store_id, uniqueness: { scope: :part_id }

  after_save :record_price, if: :saved_change_to_price?

  private
    def record_price
      price_points.create!(price: price, recorded_at: checked_at)
    end
end
