class NationalitiesController < ApplicationController
  def show
    @nationality = Nationality.find_by!(slug: params[:slug])
    @brands = @nationality.brands
    @parts = Part.where(id: Fitment.joins(:vehicle_model).where(vehicle_models: { brand_id: @brands }).select(:part_id))
      .includes(:offers, fitments: { vehicle_model: :brand }).order(:name)
  end
end
