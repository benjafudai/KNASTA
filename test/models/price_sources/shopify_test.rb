require "test_helper"

class PriceSources::ShopifyTest < ActiveSupport::TestCase
  setup do
    @store = stores(:msrepuestos)
    @catalog = JSON.parse(file_fixture("shopify_products.json").read)
  end

  # Serves the fixture as page 1 and an empty page after it, recording the URLs asked for.
  def fake_http(requests = [])
    ->(uri) { requests << uri.to_s; uri.to_s.include?("page=1") ? @catalog : { "products" => [] } }
  end

  test "downloads the catalog page by page" do
    requests = []
    PriceSources::Shopify.sync(@store, http: fake_http(requests), pause: 0)

    assert_equal [ "https://www.msrepuestos.cl/products.json?limit=250&page=1",
                   "https://www.msrepuestos.cl/products.json?limit=250&page=2" ], requests
    assert_equal 3, @store.store_listings.count, "the product without a price is skipped"

    optico = @store.store_listings.find_by!(external_id: "7000000000002")
    assert_equal 136_740, optico.price
    assert_not optico.available
    assert_equal "https://www.msrepuestos.cl/products/optico-derecho-hyundai-staria-2020-25-alternativo-92102cg000", optico.url
  end

  test "removes products the store no longer lists" do
    PriceSources::Shopify.sync(@store, http: fake_http, pause: 0)
    @catalog["products"].shift

    travel 1.minute do
      PriceSources::Shopify.sync(@store, http: fake_http, pause: 0)
    end
    assert_nil @store.store_listings.find_by(external_id: "7000000000001")
  end

  test "matches a part by the code in the product title" do
    PriceSources::Shopify.sync(@store, http: fake_http, pause: 0)

    result = PriceSources::Shopify.fetch(parts(:filtro_hyundai), @store)

    assert_equal 5_300, result[:price]
    assert result[:in_stock]
    assert_match "2630035505", result[:url]
  end

  test "returns nothing for parts the store doesn't sell" do
    PriceSources::Shopify.sync(@store, http: fake_http, pause: 0)

    assert_nil PriceSources::Shopify.fetch(parts(:pastillas_yaris), @store)
  end
end
