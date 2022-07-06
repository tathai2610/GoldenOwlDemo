FactoryBot.define do
  factory :cart_item do
    association :user 
    association :shop 
    association :product 
    quantity { rand(1..100) }
  end
end
