require "test_helper"

class UpdatePricesJobTest < ActiveJob::TestCase
  test "saves an offer for every part at every store" do
    UpdatePricesJob.perform_now

    assert_equal Part.count * Store.count, Offer.count
    assert Offer.where(part: parts(:bateria_gol)).all?(&:persisted?)
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
