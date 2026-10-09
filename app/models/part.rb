class Part < ApplicationRecord
  belongs_to :category
  has_many :fitments, dependent: :destroy
  has_many :vehicle_models, through: :fitments
  has_many :offers, -> { order(:price) }, dependent: :destroy

  validates :name, :slug, :manufacturer, :code, presence: true
  validates :slug, uniqueness: true

  def to_param = slug

  def best_offer
    offers.find(&:in_stock?)
  end

  def stores_in_stock
    offers.count(&:in_stock?)
  end
end
