FactoryBot.define do
  factory :city do
    name { Faker::Lorem.word.capitalize }
    shipping_code { 220 }
  end
end
