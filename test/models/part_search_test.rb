require "test_helper"

class PartSearchTest < ActiveSupport::TestCase
  def slugs(params)
    PartSearch.new(params).results.map(&:slug)
  end

  test "every word must match the part or a vehicle it fits" do
    assert_equal [ "pastillas-freno-yaris" ], slugs(q: "pastillas yaris")
  end

  test "text search ignores accents and case" do
    assert_equal [ "bateria-gol" ], slugs(q: "ELECTRICO")
  end

  test "filters by brand, model, year and category" do
    assert_equal [ "pastillas-freno-yaris" ], slugs(marca: "toyota")
    assert_equal [ "pastillas-freno-yaris" ], slugs(marca: "toyota", modelo: "Yaris")
    assert_empty slugs(marca: "toyota", anio: "2010")
    assert_equal [ "bateria-gol" ], slugs(marca: "volkswagen", categoria: "electrico")
  end

  test "sorts by lowest in-stock price, parts without stock last" do
    assert_equal %w[pastillas-gol pastillas-freno-yaris bateria-gol filtro-aceite-hyundai], slugs(orden: "precio-asc")
    assert_equal %w[pastillas-freno-yaris pastillas-gol bateria-gol filtro-aceite-hyundai], slugs(orden: "precio-desc")
  end

  test "ignores unknown filters and sort values" do
    search = PartSearch.new(marca: "nope", anio: "abc", orden: "hack")
    assert_nil search.brand
    assert_nil search.year
    assert_equal "precio-asc", search.sort
    assert_equal 0, search.active_filters
  end
end
