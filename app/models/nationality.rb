class Nationality < ApplicationRecord
  has_many :brands, -> { order(:name) }, dependent: :restrict_with_error

  validates :name, :slug, :flag, presence: true
  validates :slug, uniqueness: true

  scope :ordered, -> { order(:position) }

  def to_param = slug
end
