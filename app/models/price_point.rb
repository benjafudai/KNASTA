class PricePoint < ApplicationRecord
  belongs_to :offer

  validates :price, :recorded_at, presence: true
end
