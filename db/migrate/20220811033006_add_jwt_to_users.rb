class AddJwtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :jwt, :string

    User.all.each do |user|
      payload = {
        id: user.id,
        email: user.email
      }.to_json

      user.update(jwt: JWT.encode(payload, ENV['JWT_KEY'], 'HS256'))
    end

    change_column_null :users, :jwt, false
  end
end
