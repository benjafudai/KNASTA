# A product as a store lists it in its own catalog (downloaded by the store's price source).
# Parts are matched to listings by code: the listing's SKU or a part number in its title.
class StoreListing < ApplicationRecord
  belongs_to :store

  validates :external_id, :title, :url, :synced_at, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }

  scope :with_code, ->(code) { where("store_listings.codes @> ARRAY[?]::varchar[]", code) }

  # Upper-case letters and digits only, so "58101-1RA00" and "581011ra00" compare equal.
  def self.normalize_code(code)
    code.to_s.upcase.gsub(/[^A-Z0-9]/, "")
  end

  # The SKU plus every title word that looks like a part number: 6+ characters with a digit,
  # e.g. "Filtro Aceite Hyundai Accent Original 2630035505" -> ["2630035505"].
  def self.extract_codes(title, sku)
    words = title.to_s.split(%r{[\s/,()]+})
    [ sku, *words ].map { |word| normalize_code(word) }.select { |word| word.length >= 6 && word.match?(/\d/) }.uniq
  end
end
