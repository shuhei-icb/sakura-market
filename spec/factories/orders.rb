FactoryBot.define do
  factory :order do
    total_price { 1_000 }
    cash_on_delivery { 330 }
    user { nil }
  end
end
