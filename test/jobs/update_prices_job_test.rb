require "test_helper"

class UpdatePricesJobTest < ActiveJob::TestCase
  test "saves an offer for every part at every demo store" do
    UpdatePricesJob.perform_now

    demo_stores = Store.where(source: "demo")
    assert_equal Part.count * demo_stores.count, Offer.where(store: demo_stores).count
  end

  test "marks the offer unavailable when the store stops selling the part" do
    offer = Offer.create!(part: parts(:pastillas_yaris), store: stores(:msrepuestos), price: 40_000,
                          url: "https://www.msrepuestos.cl/products/x", in_stock: true, checked_at: 1.day.ago)

    UpdatePricesJob.perform_now

    assert_not offer.reload.in_stock?
    assert_equal 40_000, offer.price
  end

  test "records price history only when the price changes" do
    offer = offers(:pastillas_yaris_a)

    assert_difference -> { offer.price_points.count }, 1 do
      offer.update!(price: 31_000, checked_at: Time.current)
    end
    assert_no_difference -> { offer.price_points.count } do
      offer.update!(checked_at: Time.current)
    end
  end
end
