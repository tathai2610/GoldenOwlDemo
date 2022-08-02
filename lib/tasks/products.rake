namespace :products do
  desc "initalize 50 products"
  task init: :environment do
    50.times do |i|
      p = Product.new(
        name: Faker::Lorem.sentence.gsub('.', ''), 
        description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", 
        price: Faker::Number.number(digits: 4) * 100,
        shop_id: rand(1..10), 
        quantity: rand(50..100)
      )
      p.images.attach([io: File.open(Rails.root.join('app', 'assets', 'images', 'default.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg'])
      p.save
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
