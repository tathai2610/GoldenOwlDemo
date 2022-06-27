class AddStateToShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :state, :string
  end
end
