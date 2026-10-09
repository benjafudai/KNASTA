class CreateOffers < ActiveRecord::Migration[8.1]
  def change
    create_table :offers do |t|
      t.references :part, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.integer :price, null: false
      t.string :url, null: false
      t.boolean :in_stock, null: false, default: true
      t.datetime :checked_at, null: false

      t.timestamps
    end
    add_index :offers, [ :part_id, :store_id ], unique: true
  end
end
