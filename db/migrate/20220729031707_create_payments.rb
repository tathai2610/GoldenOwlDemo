class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.integer :status, default: 0
      t.string :token
      t.string :charge_id
      t.references :order, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
