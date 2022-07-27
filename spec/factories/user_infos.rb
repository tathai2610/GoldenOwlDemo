FactoryBot.define do
  factory :user_info do
    name { Faker::Lorem.words.map(&:capitalize).join(' ') }
    phone { "0924150409" }
    user { nil }
  end
end
