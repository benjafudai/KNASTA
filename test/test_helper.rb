ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Tests never reach real stores; tests that need a catalog pass their own http.
    PriceSources::Shopify.http = ->(uri) { raise "Sin red en los tests: #{uri}" }
  end
end
