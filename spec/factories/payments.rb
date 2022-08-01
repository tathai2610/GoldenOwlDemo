FactoryBot.define do
  factory :payment do
    status { 1 }
    token { "MyString" }
    charge_id { "MyString" }
  end
end
