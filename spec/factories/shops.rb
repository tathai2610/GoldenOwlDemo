FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
    association :user, factory: :seller 
  end
end
