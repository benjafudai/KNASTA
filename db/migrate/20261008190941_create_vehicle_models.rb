class CreateVehicleModels < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_models do |t|
      t.references :brand, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :vehicle_models, [ :brand_id, :name ], unique: true
  end
end
