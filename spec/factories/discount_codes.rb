FactoryBot.define do
  factory :discount_code do
    code { "MyString" }
    percentage { 1 }
    description { "MyText" }
    minimum_amount { "" }
    maximum_discount { "" }
    max_uses { 1 }
  end
end
