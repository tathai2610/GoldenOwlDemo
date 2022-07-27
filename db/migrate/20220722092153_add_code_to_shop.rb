class AddCodeToShop < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :code, :int
  end
end
