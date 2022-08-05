require "open-uri"

namespace :ratings do
  desc "initialize rating reviews"
  task init: :environment do 
    100.times do |i|
      rating = Rating.create(user_id: User.pluck(:id).sample, 
                    product_id: Product.pluck(:id).sample,
                    content: Faker::Lorem.paragraph,
                    star: rand(1..5))

      rand(1..10).times do 
        rating.images.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ["random"])), filename: "rating-#{rating.id}", content_type: 'image/jpg')
      end

      puts i
    end
  end
end
