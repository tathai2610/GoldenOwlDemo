FactoryBot.define do
  factory :district do
    name { Faker::Lorem.word.capitalize }
    city { nil }
    shipping_code { 1572 }
  end
end
