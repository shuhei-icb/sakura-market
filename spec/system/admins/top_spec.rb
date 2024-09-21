describe '管理者トップページ' do
  describe '閲覧' do
    it '未ログイン時は閲覧できない' do
      visit admins_root_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_admin_session_path)
    end
  end
end
