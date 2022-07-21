FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
    association :user
    state { "pending" }
    phone { "333 333 3333" }
  end
end
