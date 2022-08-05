FactoryBot.define do
  factory :rating do
    user { nil }
    product { nil }
    content { "MyText" }
    star { "" }
    images { nil }
  end
end
