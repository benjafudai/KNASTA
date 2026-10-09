# Each store points (Store#source) at a class in this namespace that knows how to read
# that store's price for a part. To add a real store, create a class with the same
# interface as PriceSources::Demo and set the store's `source` to its name.
module PriceSources
  def self.for(name)
    "PriceSources::#{name.to_s.camelize}".safe_constantize ||
      raise(ArgumentError, "Fuente de precios desconocida: #{name.inspect}")
  end
end
