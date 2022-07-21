class DropOrderProducts < ActiveRecord::Migration[6.1]
  def change
    drop_table :order_products
  end
end
