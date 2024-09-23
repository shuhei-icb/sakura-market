Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
end

User.find_or_create_by!(email: 'user@example.com') do |user|
  user.name = 'テストユーザー'
  user.password = 'password'
  user.address = '東京都中央区日本橋1-1'
end
