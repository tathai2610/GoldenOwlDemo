FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence.gsub('.', '') }
    description { Faker::Lorem.sentences.join(" ") }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :shop
  end
end
