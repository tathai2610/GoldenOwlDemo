FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence.gsub('.', '') }
    description { Faker::Lorem.sentences.join(" ") }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :shop
    after(:build) do |product|
      product.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg') 
    end
  end
end
