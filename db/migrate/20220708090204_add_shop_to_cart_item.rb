class AddShopToCartItem < ActiveRecord::Migration[6.1]
  def change
    add_reference :cart_items, :shop, null: false, foreign_key: true
  end
end
