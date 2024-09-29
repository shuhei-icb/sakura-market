RSpec.describe 'ユーザー' do
  describe 'ログイン' do
    it '認証済みのユーザーがログインに成功する' do
      user = create(:user, email: 'sakura@example.com', password: 'password')
      user.confirm
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'sakura@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path(my_page_path)
    end

    it '認証されていないユーザーはログインできない' do
      create(:user, email: 'sakura@example.com', password: 'password')
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'sakura@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスの本人確認が必要です。'
      expect(page).to have_current_path(new_user_session_path)
    end

    it '入力が不正な場合、ログインボタンを押下後、ログインされない' do
      create(:user, email: 'sakura@example.com', password: 'password')
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'invalid@example.com'
      fill_in 'パスワード', with: 'invalid'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスもしくはパスワードが不正です。'
    end
  end

  describe '登録' do
    it '登録ボタンを押下後、ユーザー登録が完了する' do
      visit new_user_registration_path
      fill_in '名前', with: 'さくら太郎'
      fill_in 'メールアドレス', with: 'sakura@example.com'
      fill_in 'パスワード', match: :first, with: 'password'
      fill_in '確認用パスワード', match: :first, with: 'password'
      fill_in '住所', match: :first, with: '東京都中央区日本橋1-1さくらビル2階'
      click_button '登録する'
      expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからメールアドレスを認証してください。'

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include('sakura@example.com')
      expect(email.subject).to include('メールアドレスの認証について')

      # メールのリンクからアカウントを有効化
      confirmation_token = email.body.match(/confirmation_token=([^"]+)/)[1].chomp
      visit user_confirmation_path(confirmation_token:)
      expect(page).to have_content('メールアドレスの認証が完了しました。')
      expect(page).to have_current_path(new_user_session_path)
    end

    it '入力が不正な場合、登録ボタンを押下後、データが登録されない' do
      visit new_user_registration_path
      fill_in '名前', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', match: :first, with: 'pass'
      fill_in '確認用パスワード', match: :first, with: 'password'
      click_button '登録する'
      expect(page).to have_content '名前を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'パスワードは6文字以上で入力してください'
      expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
    end

    it '有効化リンクが期限切れの場合、認証されない' do
      user = create(:user, email: 'sakura@example.com')
      user.send_confirmation_instructions
      user.update(confirmation_sent_at: 2.days.ago)

      email = ActionMailer::Base.deliveries.last
      confirmation_token = email.body.match(/confirmation_token=([^"]+)/)[1].chomp
      visit user_confirmation_path(confirmation_token:)
      expect(page).to have_content('メールアドレスの期限が切れました。1日 までに確認する必要があります。 新しくリクエストしてください。')
    end
  end
end
