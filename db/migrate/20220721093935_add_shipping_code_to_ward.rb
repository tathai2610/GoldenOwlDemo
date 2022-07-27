class AddShippingCodeToWard < ActiveRecord::Migration[6.1]
  def change
    add_column :wards, :shipping_code, :string
  end
end
