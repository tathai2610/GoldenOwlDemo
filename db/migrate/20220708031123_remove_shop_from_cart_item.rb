class RemoveShopFromCartItem < ActiveRecord::Migration[6.1]
  def change
    remove_column :cart_items, :shop_id, :integer 
  end
end
