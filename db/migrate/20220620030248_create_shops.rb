class CreateShops < ActiveRecord::Migration[6.1]
  def change
    create_table :shops do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.integer :products_count

      t.timestamps
    end
  end
end
