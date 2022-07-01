FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
    association :user
    state { "pending" }
  end
end
