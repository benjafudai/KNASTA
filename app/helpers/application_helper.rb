module ApplicationHelper
  def clp(amount)
    number_to_currency(amount)
  end

  def fits_summary(part)
    part.fitments.map { |f| "#{f.vehicle_model.brand.name} #{f.vehicle_model.name} #{f.years}" }.join(" · ")
  end
end
