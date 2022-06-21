FactoryBot.define do
  factory :category_product do
    association :product
    association :category
  end
end
