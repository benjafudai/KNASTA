# Nationality is the brand's country of origin, not where a given model is built.
class Brand < ApplicationRecord
  belongs_to :nationality
  has_many :vehicle_models, -> { order(:name) }, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  def to_param = slug
end
