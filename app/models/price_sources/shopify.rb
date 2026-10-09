require "net/http"

# Stores built on Shopify publish their whole catalog at /products.json, which their
# robots.txt allows. We download it once per update (a few requests per store, with a pause
# between pages) and then match parts against it locally by code.
module PriceSources
  class Shopify
    PAGE_SIZE = 250
    MAX_PAGES = 200
    USER_AGENT = "KNASTA/1.0 (+https://github.com/benjafudai/KNASTA)".freeze

    # How catalog pages are downloaded; tests swap it for a fake.
    cattr_accessor :http, default: ->(uri) { get_json(uri) }

    def self.sync(store, http: self.http, pause: 1)
      started_at = Time.current

      1.upto(MAX_PAGES) do |page|
        products = http.call(URI.join(store.url, "/products.json?limit=#{PAGE_SIZE}&page=#{page}"))["products"]
        break if products.blank?

        rows = products.filter_map { |product| listing_row(store, product, started_at) }
        StoreListing.upsert_all(rows, unique_by: [ :store_id, :external_id ]) if rows.any?
        sleep pause
      end

      # Products the store no longer lists.
      store.store_listings.where(synced_at: ...started_at).delete_all
    end

    # Cheapest listing for the part's code, preferring ones in stock.
    def self.fetch(part, store)
      listing = store.store_listings.with_code(StoreListing.normalize_code(part.code))
        .order(available: :desc, price: :asc).first
      return unless listing

      { price: listing.price, url: listing.url, in_stock: listing.available }
    end

    def self.listing_row(store, product, synced_at)
      variants = Array(product["variants"])
      variant = variants.select { |v| v["available"] }.min_by { |v| v["price"].to_d } || variants.first
      return unless variant

      price = variant["price"].to_d.round.to_i
      return unless price.positive?

      {
        store_id: store.id,
        external_id: product["id"].to_s,
        title: product["title"],
        sku: variant["sku"].presence,
        codes: StoreListing.extract_codes(product["title"], variant["sku"]),
        price: price,
        available: variant["available"] != false,
        url: URI.join(store.url, "/products/#{product["handle"]}").to_s,
        vendor: product["vendor"],
        product_type: product["product_type"],
        synced_at: synced_at
      }
    end
    private_class_method :listing_row

    def self.get_json(uri)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 30) do |http|
        http.get(uri.request_uri, "User-Agent" => USER_AGENT, "Accept" => "application/json")
      end
      raise "#{uri} respondió #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end
    private_class_method :get_json
  end
end
