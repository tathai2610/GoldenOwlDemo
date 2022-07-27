FactoryBot.define do
  factory :order do
    user { nil }
    shop { nil }
    total_price { "9.99" }
  end
end
