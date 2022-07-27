class AddCodeToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :code, :string
  end
end
