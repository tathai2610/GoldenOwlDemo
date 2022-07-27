class AddShippingCodeToCity < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :shipping_code, :int
  end
end
