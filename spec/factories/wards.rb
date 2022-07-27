FactoryBot.define do
  factory :ward do
    name { Faker::Lorem.word.capitalize }
    district { nil }
    shipping_code { "550110" }
  end
end
