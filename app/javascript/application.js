// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Lets the app be installed on phones and keeps visited pages available offline.
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker")
}
