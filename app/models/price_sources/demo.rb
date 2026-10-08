require "zlib"

# Generates plausible, slowly changing prices so the app has data to show
# before real stores are connected.
module PriceSources
  class Demo
    BASE_PRICE = {
      "filtros" => 9_000, "frenos" => 28_000, "suspension" => 55_000, "motor" => 90_000,
      "encendido" => 12_000, "electrico" => 85_000, "iluminacion" => 120_000,
      "carroceria" => 140_000, "transmision" => 180_000, "refrigeracion" => 95_000,
      "lubricantes" => 38_000
    }.freeze

    # Returns { price:, url:, in_stock: } for the part at the store, or nil when
    # the store doesn't sell it.
    def self.fetch(part, store, today: Date.current)
      seed = Zlib.crc32("#{part.slug}:#{store.slug}")
      daily = Zlib.crc32("#{part.slug}:#{store.slug}:#{today}")
      base = BASE_PRICE.fetch(part.category.slug, 30_000)
      price = (base * (0.8 + (seed % 50) / 100.0) * (0.97 + (daily % 7) / 100.0) / 10).round * 10

      {
        price: price,
        url: "#{store.url}/buscar?q=#{ERB::Util.url_encode(part.code)}",
        in_stock: daily % 5 != 0
      }
    end
  end
end
