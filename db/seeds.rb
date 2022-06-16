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

50.times do 
  p = Product.create(name: Faker::Lorem.sentence[0..-1].gsub('.', ''), description: Faker::Lorem.paragraphs.join(' '), price: Faker::Number.decimal(l_digits: 2, r_digits: 2))
  p.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
  2.times do 
    p.categories << Category.find(rand(1..20))
  end
end