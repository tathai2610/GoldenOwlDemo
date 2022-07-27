FactoryBot.define do
  factory :street do
    name { Faker::Lorem.words.join(' ').capitalize }
  end
end
