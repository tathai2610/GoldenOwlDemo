# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

20.times do 
  c = Category.create(name: Faker::Lorem.unique.word.capitalize)
end

20.times do |i|
  u = User.new(email: "tester#{i+1}@gmail.com", password: "123123", password_confirmation: "123123")
  u.confirm 
  u.save
  if i < 10 
    u.add_role :seller 
    Shop.create(user: u, name: Faker::Lorem.sentence.gsub('.', ''), description: Faker::Lorem.paragraphs.join(' '))
  end
end

50.times do |i|
  p = Product.new(name: Faker::Lorem.sentence.gsub('.', ''), description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", price: Faker::Number.decimal(l_digits: 2, r_digits: 2), shop_id: rand(1..10))
  p.images.attach([io: File.open(Rails.root.join('app', 'assets', 'images', 'default.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg'])
  p.save
  2.times do 
    p.categories << Category.find(rand(1..20))
  end
end

5.times do |i| 
  s = Shop.find(rand(1..10))
  CartItem.create(user: User.first, shop: s, product: s.products.last)
end




