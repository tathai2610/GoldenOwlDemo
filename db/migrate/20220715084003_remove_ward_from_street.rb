class RemoveWardFromStreet < ActiveRecord::Migration[6.1]
  def change
    remove_reference :streets, :ward, null: false, foreign_key: true
  end
end
