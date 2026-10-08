# Search and filters for the parts listing (text, brand, model, year, category, sort).
class PartSearch
  SORTS = {
    "precio-asc" => "Menor precio",
    "precio-desc" => "Mayor precio",
    "nombre" => "Nombre"
  }.freeze

  # Text a part can be found by: its name, maker, code, category and every brand/model it fits.
  SEARCHABLE = <<~SQL.squish.freeze
    unaccent(concat_ws(' ', parts.name, parts.manufacturer, parts.code, categories.name,
      string_agg(concat_ws(' ', brands.name, vehicle_models.name), ' ')))
  SQL

  attr_reader :q, :brand, :model, :year, :category, :sort

  def initialize(params = {})
    @q = params[:q].to_s.strip
    @brand = Brand.find_by(slug: params[:marca]) if params[:marca].present?
    @model = @brand&.vehicle_models&.find_by(name: params[:modelo]) if params[:modelo].present?
    @year = params[:anio].to_i if params[:anio].to_s.match?(/\A\d{4}\z/)
    @category = Category.find_by(slug: params[:categoria]) if params[:categoria].present?
    @sort = SORTS.key?(params[:orden]) ? params[:orden] : "precio-asc"
  end

  def active_filters
    [ brand, model, year, category ].compact.size
  end

  def results
    scope = Part.includes(:offers, fitments: { vehicle_model: :brand })
    scope = scope.where(category: category) if category
    scope = scope.where(id: fitting_part_ids) if brand || model || year
    scope = scope.where(id: matching_part_ids) if q.present?
    sorted(scope)
  end

  private
    def fitting_part_ids
      fitments = Fitment.joins(:vehicle_model)
      fitments = fitments.where(vehicle_models: { brand_id: brand.id }) if brand
      fitments = fitments.where(vehicle_model: model) if model
      fitments = fitments.where("fitments.year_from <= :y AND fitments.year_to >= :y", y: year) if year
      fitments.select(:part_id)
    end

    # Every word of the query must appear somewhere in SEARCHABLE.
    def matching_part_ids
      relation = Part.joins(:category)
        .left_joins(fitments: { vehicle_model: :brand })
        .group("parts.id", "categories.name")

      q.split.each do |word|
        relation = relation.having("#{SEARCHABLE} ILIKE unaccent(?)", "%#{Part.sanitize_sql_like(word)}%")
      end
      relation.select("parts.id")
    end

    def sorted(scope)
      return scope.order(:name) if sort == "nombre"

      best_price = Arel::Nodes::Grouping.new(
        Offer.where("offers.part_id = parts.id AND offers.in_stock").select("MIN(offers.price)").arel
      )
      order = sort == "precio-desc" ? best_price.desc : best_price.asc
      scope.order(order.nulls_last, :name)
    end
end
