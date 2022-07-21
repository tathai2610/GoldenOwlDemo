class CreateStreets < ActiveRecord::Migration[6.1]
  def change
    create_table :streets do |t|
      t.string :name
      t.references :ward, null: false, foreign_key: true

      t.timestamps
    end
  end
end
