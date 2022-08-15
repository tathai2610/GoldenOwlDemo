class ChangeDefaultJwtFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :jwt, true
  end
end
