FactoryBot.define do
  factory :order_item do
    price { 1_000 }
    order { nil }
    product { nil }
  end
end
