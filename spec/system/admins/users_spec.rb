describe 'ユーザー' do
  describe '一覧' do
    it 'ユーザーの一覧が表示される' do
      admin = create(:admin)
      create(:user, name: 'さくら太郎', email: 'sakura@example.com')
      create(:user, name: 'サクラ花子', email: 'h-sakura@example.com')
      sign_in admin
      visit admins_users_path
      expect(page).to have_link 'さくら太郎'
      expect(page).to have_content 'sakura@example.com'
      expect(page).to have_link 'サクラ花子'
      expect(page).to have_content 'h-sakura@example.com'
      expect(page).to have_link '編集'
    end

    it '未ログイン時は表示されない' do
      visit admins_users_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_admin_session_path)
    end
  end

  describe '詳細' do
    it '未ログイン時は表示されない' do
      user = create(:user)
      visit admins_user_path(user)
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_admin_session_path)
    end
  end

  describe '編集' do
    it 'ユーザーを編集できる' do
      admin = create(:admin)
      create(:user, name: 'さくら太郎', email: 'sakura@example.com', address: '東京都中央区日本橋1-1さくらビル2階')
      sign_in admin
      visit admins_users_path
      expect(page).to have_link 'さくら太郎'
      click_on '編集'
      fill_in '名前', with: 'RSpec太郎'
      fill_in 'メールアドレス', with: 'rspec@example.com'
      fill_in '住所', with: '神奈川県横浜市中区みなとみらい1-1'
      click_button '更新する'
      expect(page).to have_content '変更が完了しました。'
      expect(page).to have_content 'RSpec太郎'
      expect(page).to have_content 'rspec@example.com'
      expect(page).to have_content '神奈川県横浜市中区みなとみらい1-1'
    end

    it '入力が不正な場合、更新されない' do
      admin = create(:admin)
      create(:user, name: 'さくら太郎')
      sign_in admin
      visit admins_users_path
      expect(page).to have_link 'さくら太郎'
      click_on '編集'
      fill_in '名前', with: 'RSpec太郎'
      fill_in 'メールアドレス', with: ''
      click_button '更新する'
      expect(page).to have_content '変更に失敗しました。'
      visit admins_users_path
      expect(page).not_to have_content 'RSpec太郎'
    end
  end

  describe '削除' do
    it 'ユーザーを削除できる' do
      admin = create(:admin)
      user = create(:user, name: 'さくら太郎', email: 'sakura@example.com')
      sign_in admin
      visit admins_user_path(user)
      expect(page).to have_content 'さくら太郎'
      accept_confirm do
        click_button 'このユーザーを削除する'
      end
      expect(page).to have_content '削除が完了しました。'
      expect(page).not_to have_link 'さくら太郎'
      expect(page).not_to have_content 'sakura@example.com'
    end
  end
end
