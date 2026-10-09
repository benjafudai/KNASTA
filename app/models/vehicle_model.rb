class VehicleModel < ApplicationRecord
  belongs_to :brand
  has_many :fitments, dependent: :destroy
  has_many :parts, through: :fitments

  validates :name, presence: true, uniqueness: { scope: :brand_id }
end
