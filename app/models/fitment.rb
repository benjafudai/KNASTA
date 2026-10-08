class Fitment < ApplicationRecord
  belongs_to :part
  belongs_to :vehicle_model

  validates :year_from, :year_to, presence: true, numericality: { only_integer: true }
  validates :vehicle_model_id, uniqueness: { scope: :part_id }

  def years = "#{year_from}–#{year_to}"
end
