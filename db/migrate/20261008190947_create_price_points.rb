class CreatePricePoints < ActiveRecord::Migration[8.1]
  def change
    create_table :price_points do |t|
      t.references :offer, null: false, foreign_key: true
      t.integer :price, null: false
      t.datetime :recorded_at, null: false

      t.timestamps
    end
  end
end
