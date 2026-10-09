# Refreshes every store's prices: first downloads the store's catalog when its price source
# keeps one (e.g. Shopify stores), then asks the source for the price of every part.
# Offer records a PricePoint whenever the price changes, which builds the price history.
class UpdatePricesJob < ApplicationJob
  queue_as :default

  def perform
    parts = Part.includes(:category).to_a

    Store.find_each do |store|
      source = store.price_source
      sync_catalog(source, store)

      parts.each do |part|
        update_offer(source, store, part)
      rescue StandardError => e
        Rails.logger.error("[UpdatePricesJob] #{store.slug}/#{part.slug}: #{e.class}: #{e.message}")
      end
    end
  end

  private
    # A failed download keeps the previous catalog, so prices stay as they were.
    def sync_catalog(source, store)
      source.sync(store) if source.respond_to?(:sync)
    rescue StandardError => e
      Rails.logger.error("[UpdatePricesJob] catálogo de #{store.slug}: #{e.class}: #{e.message}")
    end

    def update_offer(source, store, part)
      result = source.fetch(part, store)
      offer = Offer.find_or_initialize_by(part: part, store: store)

      if result
        offer.update!(result.merge(checked_at: Time.current))
      elsif offer.persisted?
        # The store stopped selling it: keep the last price but show it as unavailable.
        offer.update!(in_stock: false, checked_at: Time.current)
      end
    end
end
