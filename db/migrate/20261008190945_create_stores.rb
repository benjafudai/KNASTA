class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :url, null: false
      t.string :source

      t.timestamps
    end
    add_index :stores, :slug, unique: true
  end
end
