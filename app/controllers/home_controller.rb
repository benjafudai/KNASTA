class HomeController < ApplicationController
  def index
    @nationalities = Nationality.ordered.includes(:brands)
    @categories = Category.ordered
    @brand_count = Brand.count
  end
end
