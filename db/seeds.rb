# Loads the brand catalog, categories, demo stores and sample parts, then fills in
# prices. Safe to run more than once: bin/rails db:seed
require_relative "seeds/brands"

NATIONALITIES.each_with_index do |(slug, data), index|
  nationality = Nationality.find_or_initialize_by(slug: slug)
  nationality.update!(name: data[:name], flag: data[:flag], position: index)

  data[:brands].each do |brand_slug, name, note|
    Brand.find_or_initialize_by(slug: brand_slug).update!(name: name, note: note, nationality: nationality)
  end
end

[
  [ "filtros", "Filtros" ],
  [ "frenos", "Frenos" ],
  [ "suspension", "Suspensión y dirección" ],
  [ "motor", "Motor" ],
  [ "encendido", "Encendido" ],
  [ "electrico", "Eléctrico y baterías" ],
  [ "iluminacion", "Iluminación" ],
  [ "carroceria", "Carrocería" ],
  [ "transmision", "Transmisión y embrague" ],
  [ "refrigeracion", "Refrigeración" ],
  [ "lubricantes", "Aceites y lubricantes" ]
].each_with_index do |(slug, name), index|
  Category.find_or_initialize_by(slug: slug).update!(name: name, position: index)
end

# Real stores. Their catalogs are public Shopify catalogs (see PriceSources::Shopify).
[
  [ "msrepuestos", "MS Repuestos", "https://www.msrepuestos.cl" ],      # Hyundai, Kia, SsangYong, Maxus, MG
  [ "repuestos-europa", "Repuestos Europa", "https://www.repuestoseuropa.cl" ] # BMW, Mercedes, VW, Audi, Volvo...
].each do |slug, name, url|
  Store.find_or_initialize_by(slug: slug).update!(name: name, url: url, source: "shopify")
end

# Stores with generated prices, so the app has data to show while developing.
unless Rails.env.production?
  [
    [ "demo-a", "Tienda Demo A", "https://example.com/tienda-a" ],
    [ "demo-b", "Tienda Demo B", "https://example.com/tienda-b" ],
    [ "demo-c", "Tienda Demo C", "https://example.com/tienda-c" ]
  ].each do |slug, name, url|
    Store.find_or_initialize_by(slug: slug).update!(name: name, url: url, source: "demo")
  end
end

JSON.parse(File.read(Rails.root.join("db/seeds/parts.json"))).each do |data|
  part = Part.find_or_initialize_by(slug: data["id"])
  part.update!(
    name: data["name"],
    manufacturer: data["manufacturer"],
    code: data["code"],
    category: Category.find_by!(slug: data["category"])
  )

  data["compatibleWith"].each do |fit|
    vehicle_model = Brand.find_by!(slug: fit["brand"]).vehicle_models.find_or_create_by!(name: fit["model"])
    part.fitments.find_or_initialize_by(vehicle_model: vehicle_model)
      .update!(year_from: fit["years"].first, year_to: fit["years"].last)
  end
end

UpdatePricesJob.perform_now
