class PartsController < ApplicationController
  def show
    @part = Part.includes(:category, offers: :store, fitments: { vehicle_model: :brand }).find_by!(slug: params[:slug])
  end
end
