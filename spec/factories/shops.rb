FactoryBot.define do
  factory :shop do
    name { "Anniver" }
    description { Faker::Lorem.sentence }
    association :user
    state { "pending" }
    phone { "0924150409" }
  end
end
