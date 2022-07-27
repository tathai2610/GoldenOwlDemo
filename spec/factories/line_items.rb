FactoryBot.define do
  factory :line_item do
    line_itemable { nil }
    product { nil }
    quantity { 1 }
  end
end
