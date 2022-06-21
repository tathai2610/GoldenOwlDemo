class AddDefaultProductCountToShops < ActiveRecord::Migration[6.1]
  def change
    change_column_default :shops, :products_count, 0
  end
end
