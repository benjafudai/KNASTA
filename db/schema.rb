# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_08_191130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "nationality_id", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nationality_id"], name: "index_brands_on_nationality_id"
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "fitments", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.bigint "vehicle_model_id", null: false
    t.integer "year_from", null: false
    t.integer "year_to", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id", "vehicle_model_id"], name: "index_fitments_on_part_id_and_vehicle_model_id", unique: true
    t.index ["part_id"], name: "index_fitments_on_part_id"
    t.index ["vehicle_model_id"], name: "index_fitments_on_vehicle_model_id"
  end

  create_table "nationalities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "flag", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_nationalities_on_slug", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.bigint "store_id", null: false
    t.integer "price", null: false
    t.string "url", null: false
    t.boolean "in_stock", default: true, null: false
    t.datetime "checked_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id", "store_id"], name: "index_offers_on_part_id_and_store_id", unique: true
    t.index ["part_id"], name: "index_offers_on_part_id"
    t.index ["store_id"], name: "index_offers_on_store_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "category_id", null: false
    t.string "manufacturer", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_parts_on_category_id"
    t.index ["code"], name: "index_parts_on_code"
    t.index ["slug"], name: "index_parts_on_slug", unique: true
  end

  create_table "price_points", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.integer "price", null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_price_points_on_offer_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "url", null: false
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_stores_on_slug", unique: true
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id", "name"], name: "index_vehicle_models_on_brand_id_and_name", unique: true
    t.index ["brand_id"], name: "index_vehicle_models_on_brand_id"
  end

  add_foreign_key "brands", "nationalities"
  add_foreign_key "fitments", "parts"
  add_foreign_key "fitments", "vehicle_models"
  add_foreign_key "offers", "parts"
  add_foreign_key "offers", "stores"
  add_foreign_key "parts", "categories"
  add_foreign_key "price_points", "offers"
  add_foreign_key "vehicle_models", "brands"
end
