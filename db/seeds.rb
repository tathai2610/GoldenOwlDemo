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

  ward = Ward.find(8191)
  user_info = UserInfo.create(name: "Tyler", phone: "0924150409", user: u)
  a = Address.create(city: ward.district.city,
                     district: ward.district,
                     ward: ward,
                     street: Street.create(name: "15 anonym"),
                     addressable: user_info)
  if i < 10 
    u.add_role :seller 
    ActiveRecord::Base.transaction do 
      s = Shop.create!(user: u, name: Faker::Lorem.sentence.gsub('.', ''), description: Faker::Lorem.paragraphs.join(' '), phone: "0924150409")
      s.approve
      ward = Ward.find(10702)
      a = Address.create!(city: ward.district.city, 
                          district: ward.district, 
                          ward: ward, 
                          street: Street.create!(name: "10 anonym"),
                          addressable: s)
      response = GhnClient.new.create_store(s)
      s.update!(code: response["data"]["shop_id"])
    end
  end
end

count = 0
50.times do |i|
  p = Product.new(
    name: Faker::Lorem.sentence.gsub('.', ''), 
    description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", 
    # price: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
    price: Faker::Number.number(digits: 4) * 100,
    shop_id: rand(1..10), 
    quantity: rand(50..100)
    # code: Faker::Lorem.word.upcase
  )

  rand(1..10).times do 
    p.images.attach(io: URI.open(Faker::LoremFlickr.image), filename: p.name, content_type: 'image/png')
  end

  count += 1
  puts "Product number: #{count}"
  puts "After save: #{count}" if p.save

  2.times do 
    p.categories << Category.find(rand(1..20))
  end
end

5.times do
  s = Shop.find(rand(1..10))
  item = LineItem.find_or_create_by(line_itemable: User.first.cart, product: Product.find(rand(1..50)))
  item.update(quantity: rand(1..10))
end




