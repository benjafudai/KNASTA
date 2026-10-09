class CreateStoreListings < ActiveRecord::Migration[8.1]
  def change
    create_table :store_listings do |t|
      t.references :store, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :title, null: false
      t.string :sku
      t.string :codes, array: true, null: false, default: []
      t.integer :price, null: false
      t.boolean :available, null: false, default: true
      t.string :url, null: false
      t.string :vendor
      t.string :product_type
      t.datetime :synced_at, null: false

      t.timestamps
    end
    add_index :store_listings, [ :store_id, :external_id ], unique: true
    add_index :store_listings, :codes, using: :gin
  end
end
