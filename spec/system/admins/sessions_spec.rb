describe '管理者ログイン' do
  it 'ログインに成功する' do
    create(:admin, email: 'admin@example.com', password: 'password')
    visit new_admin_session_path
    fill_in 'admin_email', with: 'admin@example.com'
    fill_in 'admin_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    expect(page).to have_current_path(admins_root_path)
  end

  it 'メールアドレスが異なる場合、ログインに失敗する' do
    create(:admin, email: 'admin@example.com', password: 'password')
    visit new_admin_session_path
    fill_in 'admin_email', with: 'invalid@example.com'
    fill_in 'admin_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスもしくはパスワードが不正です。'
  end

  it 'パスワードが異なる場合、ログインに失敗する' do
    create(:admin, email: 'admin@example.com', password: 'password')
    visit new_admin_session_path
    fill_in 'admin_email', with: 'admin@example.com'
    fill_in 'admin_password', with: 'invalid'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスもしくはパスワードが不正です。'
  end

  it 'ログイン状態でログイン画面にアクセスすると、トップページに遷移する' do
    admin = create(:admin)
    sign_in admin
    visit new_admin_session_path
    expect(page).to have_current_path(admins_root_path)
    expect(page).to have_content 'すでにログインしています。'
  end

  it 'ログアウトに成功する' do
    admin = create(:admin)
    sign_in admin
    visit admins_root_path
    click_button 'ログアウト'
    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'ログアウトしました。'
  end
end
