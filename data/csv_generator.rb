require 'faker'
require 'csv'

CSV.open('data.csv', 'wb') do |csv|
  csv << ['name', 'description', 'price', 'quantity', 'images', 'categories']
  10.times do 
    name = Faker::Lorem.sentence.gsub('.', '')
    description = Faker::Lorem.paragraphs.join('<br>')
    price = Faker::Number.decimal(l_digits: 2, r_digits: 2)
    quantity = rand(1..100)
    image_link = 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80'
    images = []
    10.times { |i| images.push(image_link) }
    categories = []
    5.times { |i| categories.push(Faker::Lorem.word.capitalize) }
    csv << [name, description, price, quantity, images, categories]
  end
end
