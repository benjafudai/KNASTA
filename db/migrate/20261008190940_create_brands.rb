class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.references :nationality, null: false, foreign_key: true
      t.string :note

      t.timestamps
    end
    add_index :brands, :slug, unique: true
  end
end
