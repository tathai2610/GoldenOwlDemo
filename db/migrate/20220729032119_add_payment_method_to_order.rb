class AddPaymentMethodToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :payment_method, :integer, default: 0
  end
end
