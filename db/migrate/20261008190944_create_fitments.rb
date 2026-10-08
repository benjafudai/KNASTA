class CreateFitments < ActiveRecord::Migration[8.1]
  def change
    create_table :fitments do |t|
      t.references :part, null: false, foreign_key: true
      t.references :vehicle_model, null: false, foreign_key: true
      t.integer :year_from, null: false
      t.integer :year_to, null: false

      t.timestamps
    end
    add_index :fitments, [ :part_id, :vehicle_model_id ], unique: true
  end
end
