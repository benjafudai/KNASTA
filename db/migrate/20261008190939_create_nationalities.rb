class CreateNationalities < ActiveRecord::Migration[8.1]
  def change
    create_table :nationalities do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :flag, null: false
      t.integer :position

      t.timestamps
    end
    add_index :nationalities, :slug, unique: true
  end
end
