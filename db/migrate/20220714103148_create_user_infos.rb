class CreateUserInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :phone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
