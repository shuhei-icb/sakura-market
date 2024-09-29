FactoryBot.define do
  factory :user do
    name { 'さくら太郎' }
    email { 'sakura@example.com' }
    password { 'password' }
    address { '東京都中央区日本橋1-1さくらビル2階' }

    trait :confirmed do
      confirmed_at { 1.day.ago }
    end
  end
end
