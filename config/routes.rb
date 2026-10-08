Rails.application.routes.draw do
  root "home#index"

  get "nacionalidad/:slug" => "nationalities#show", as: :nationality
  get "marca/:slug" => "brands#show", as: :brand
  get "buscar" => "searches#show", as: :search
  get "repuesto/:slug" => "parts#show", as: :part

  # Installable app (PWA): app/views/pwa/*
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
