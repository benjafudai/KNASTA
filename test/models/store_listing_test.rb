require "test_helper"

class StoreListingTest < ActiveSupport::TestCase
  test "normalizes codes to letters and digits" do
    assert_equal "581011RA00", StoreListing.normalize_code("58101-1ra00")
  end

  test "finds part numbers in the SKU and title" do
    codes = StoreListing.extract_codes("Optico Derecho Hyundai Staria Alternativo 92102CG000", "92102CG000A")

    assert_includes codes, "92102CG000A"
    assert_includes codes, "92102CG000"
    assert_not_includes codes, "HYUNDAI"
  end
end
