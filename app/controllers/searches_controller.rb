class SearchesController < ApplicationController
  def show
    @search = PartSearch.new(params)
    @parts = @search.results
    @nationalities = Nationality.ordered.includes(:brands)
    @categories = Category.ordered
  end
end
