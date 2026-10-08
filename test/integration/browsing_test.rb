require "test_helper"

class BrowsingTest < ActionDispatch::IntegrationTest
  test "home groups brands by nationality" do
    get root_path

    assert_response :success
    assert_select ".nationality", 2
    assert_select ".nationality a.chip", text: "Toyota"
  end

  test "nationality and brand pages list their parts" do
    get nationality_path(nationalities(:alemania))
    assert_select ".part-card", 2

    get brand_path(brands(:toyota))
    assert_select "h1", /Toyota/
    assert_select ".part-card", 1
  end

  test "search shows matching parts" do
    get search_path(q: "pastillas", marca: "volkswagen")

    assert_response :success
    assert_select ".part-card", 1
    assert_select ".part-price", /\$20\.000/
  end

  test "part page lists prices per store with links" do
    get part_path(parts(:pastillas_yaris))

    assert_response :success
    assert_select ".offers tbody tr", 2
    assert_select ".offers tr.best td", "Tienda Demo B"
    assert_select "a[href=?]", offers(:pastillas_yaris_b).url
  end

  test "unknown brand is not found" do
    get brand_path("no-existe")
    assert_response :not_found
  end

  test "installable app manifest" do
    get pwa_manifest_path(format: :json)

    assert_response :success
    assert_equal "KNASTA", response.parsed_body["short_name"]
  end
end
