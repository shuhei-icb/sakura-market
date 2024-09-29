FactoryBot.define do
  factory :product do
    name { 'トマト' }
    price { 100 }

    trait :published do
      published { true }
    end
  end
end
