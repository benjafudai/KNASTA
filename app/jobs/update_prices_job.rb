# Asks every store's price source for the current price of every part and saves it.
# Offer records a PricePoint whenever the price changes, which builds the price history.
class UpdatePricesJob < ApplicationJob
  queue_as :default

  def perform
    parts = Part.includes(:category).to_a

    Store.find_each do |store|
      source = store.price_source

      parts.each do |part|
        result = source.fetch(part, store)
        next unless result

        offer = Offer.find_or_initialize_by(part: part, store: store)
        offer.update!(result.merge(checked_at: Time.current))
      rescue StandardError => e
        Rails.logger.error("[UpdatePricesJob] #{store.slug}/#{part.slug}: #{e.class}: #{e.message}")
      end
    end
  end
end
