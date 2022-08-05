class AddRatedToLineItems < ActiveRecord::Migration[6.1]
  def change
    add_column :line_items, :rated, :boolean, default: false
  end
end
