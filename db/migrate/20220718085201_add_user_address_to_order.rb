class AddUserAddressToOrder < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :user_address, null: false, foreign_key: { to_table: :addresses }
  end
end
