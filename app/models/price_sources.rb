# Each store points (Store#source) at a class in this namespace that knows how to read
# that store's price for a part:
#   fetch(part, store) -> { price:, url:, in_stock: } or nil when the store doesn't sell it
#   sync(store)        -> optional; downloads the store's catalog before prices are read
# Shopify stores only need a Store with source "shopify" and their home page as url.
module PriceSources
  def self.for(name)
    "PriceSources::#{name.to_s.camelize}".safe_constantize ||
      raise(ArgumentError, "Fuente de precios desconocida: #{name.inspect}")
  end
end
