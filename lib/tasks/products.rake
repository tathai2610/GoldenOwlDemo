require "open-uri"

namespace :products do
  desc "initalize 50 products"
  task init: :environment do
    count = 0
    50.times do |i|
      p = Product.new(
        name: Faker::Lorem.sentence.gsub('.', ''), 
        description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", 
        price: Faker::Number.number(digits: 4) * 100,
        shop_id: rand(1..10), 
        quantity: rand(50..100)
      )
      
      rand(1..10).times do 
        p.images.attach(io: URI.open(Faker::LoremFlickr.image(size: "600x800", search_terms: ['plants'])), filename: p.name, content_type: 'image/jpg')
      end

      count += 1
      puts count
      puts "After save: #{count}" if p.save

      2.times do 
        p.categories << Category.find(rand(1..20))
      end
    end
    
    5.times do
      s = Shop.find(rand(1..10))
      item = LineItem.find_or_create_by(line_itemable: User.first.cart, product: Product.find(Product.pluck(:id).sample))
      item.update(quantity: rand(1..10))
    end
  end

end
