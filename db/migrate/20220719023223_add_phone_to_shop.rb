class AddPhoneToShop < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :phone, :string
  end
end
