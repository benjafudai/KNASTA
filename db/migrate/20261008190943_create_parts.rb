class CreateParts < ActiveRecord::Migration[8.1]
  def change
    create_table :parts do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.references :category, null: false, foreign_key: true
      t.string :manufacturer, null: false
      t.string :code, null: false

      t.timestamps
    end
    add_index :parts, :slug, unique: true
    add_index :parts, :code
  end
end
