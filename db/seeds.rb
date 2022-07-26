# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

file = File.read('data/vietnam_provinces_districts_wards.json')
data = JSON.parse(file)

data.each do |city|
  c = City.create(name: city['ProvinceName'], shipping_code: city['ProvinceID'])

  city['districts'].each do |district|
    d = District.create(name: district['DistrictName'], city: c, shipping_code: district['DistrictID'])

    district['wards']&.each do |ward|
      Ward.create(name: ward['WardName'], district: d, shipping_code: ward['WardCode'])
    end
  end
end

20.times do 
  c = Category.create(name: Faker::Lorem.unique.word.capitalize)
end

20.times do |i|
  u = User.new(email: "tester#{i+1}@gmail.com", password: "123123", password_confirmation: "123123")
  u.confirm 
  u.save
  if i < 10 
    u.add_role :seller 
    s = Shop.create(user: u, name: Faker::Lorem.sentence.gsub('.', ''), description: Faker::Lorem.paragraphs.join(' '), phone: "333 333 3333")
    s.approve
    s.address = Address(city: City.first, district: District.first, ward: Ward.first, street: Street.find_or_create_by(name: "10 anonym"))
  end
end

50.times do |i|
  p = Product.new(
    name: Faker::Lorem.sentence.gsub('.', ''), 
    description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", 
    price: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
    shop_id: rand(1..10), 
    # code: Faker::Lorem.word.upcase
  )
  p.images.attach([io: File.open(Rails.root.join('app', 'assets', 'images', 'default.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg'])
  p.save
  2.times do 
    p.categories << Category.find(rand(1..20))
  end
end

5.times do
  s = Shop.find(rand(1..10))
  item = LineItem.find_or_create_by(line_itemable: User.first.cart, product: Product.find(rand(1..50)))
  item.update(quantity: rand(1..100))
end




