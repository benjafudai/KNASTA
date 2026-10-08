namespace :prices do
  desc "Actualiza los precios de todas las tiendas ahora (en producción corre solo cada día, ver config/recurring.yml)"
  task update: :environment do
    UpdatePricesJob.perform_now
    puts "#{Offer.count} ofertas actualizadas"
  end
end
