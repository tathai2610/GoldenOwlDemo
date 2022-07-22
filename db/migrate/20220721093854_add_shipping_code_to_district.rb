class AddShippingCodeToDistrict < ActiveRecord::Migration[6.1]
  def change
    add_column :districts, :shipping_code, :int
  end
end
