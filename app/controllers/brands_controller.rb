class BrandsController < ApplicationController
  def show
    @brand = Brand.includes(:nationality, :vehicle_models).find_by!(slug: params[:slug])
    @categories = Category.ordered
    @parts = PartSearch.new(marca: @brand.slug).results
  end
end
