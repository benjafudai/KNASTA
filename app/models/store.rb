class Store < ApplicationRecord
  has_many :offers, dependent: :destroy

  validates :name, :slug, :url, presence: true
  validates :slug, uniqueness: true

  # The class in app/models/price_sources that reads this store's prices.
  def price_source
    PriceSources.for(source)
  end
end
