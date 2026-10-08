class Category < ApplicationRecord
  has_many :parts, dependent: :restrict_with_error

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  scope :ordered, -> { order(:position) }

  def to_param = slug
end
