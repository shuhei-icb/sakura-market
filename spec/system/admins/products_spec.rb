describe '商品' do
  describe '一覧' do
    it '商品の一覧が表示される' do
      admin = create(:admin)
      create(:product, name: 'トマト', price: 300, published: false)
      create(:product, name: 'レタス', price: 100, published: true)
      sign_in admin
      visit admins_products_path
      expect(page).to have_content '1'
      expect(page).to have_link 'トマト'
      expect(page).to have_content '300円'
      expect(page).to have_content '非表示'
      expect(page).to have_content '2'
      expect(page).to have_link 'レタス'
      expect(page).to have_content '100円'
      expect(page).to have_content '表示中'
      expect(page).to have_link '編集'
    end

    it '未ログイン時は表示されない' do
      visit admins_products_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_admin_session_path)
    end
  end

  describe '詳細' do
    it '未ログイン時は表示されない' do
      product = create(:product)
      visit admins_product_path(product)
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_admin_session_path)
    end
  end

  describe '登録' do
    it '商品が登録できる' do
      admin = create(:admin)
      sign_in admin
      visit admins_products_path
      click_on '新規追加'
      fill_in '商品名', with: 'トマト'
      attach_file '商品画像', Rails.root.join('spec/fixtures/tomato-image.jpg')
      fill_in '価格', with: 100
      check '表示する'
      fill_in '商品説明', with: '# 熊本県産のトマトです。'
      click_button '登録する'
      expect(page).to have_content '登録が完了しました。'
      expect(page).to have_content '表示中'
      expect(page).to have_selector("img[src$='tomato-image.jpg']")
      expect(page).to have_content 'トマト'
      expect(page).to have_content '100円'
      expect(page).to have_selector 'h1', text: '熊本県産のトマトです。'
      expect(page).to have_button 'この商品を削除する'
    end

    it '入力が不正な場合、登録されない' do
      admin = create(:admin)
      sign_in admin
      visit admins_products_path
      click_on '新規追加'
      fill_in '商品名', with: 'トマト'
      fill_in '価格', with: ''
      click_button '登録する'
      expect(page).to have_content '登録に失敗しました。'
      visit admins_products_path
      expect(page).not_to have_content 'トマト'
    end
  end

  describe '編集' do
    it '商品を編集できる' do
      admin = create(:admin)
      create(:product, name: 'トマト', price: 100, description: '熊本県産のトマトです。')
      sign_in admin
      visit admins_products_path
      expect(page).to have_content 'トマト'
      click_on '編集'
      fill_in '商品名', with: 'レタス'
      fill_in '価格', with: '300'
      fill_in '商品説明', with: '群馬県産のレタスです。'
      click_button '更新する'
      expect(page).to have_content '変更が完了しました。'
      expect(page).to have_content 'レタス'
      expect(page).to have_content '300円'
      expect(page).to have_content '群馬県産のレタスです。'
    end

    it '入力が不正な場合、更新されない' do
      admin = create(:admin)
      product = create(:product, name: 'トマト', price: 100)
      sign_in admin
      visit edit_admins_product_path(product)
      fill_in '商品名', with: 'レタス'
      fill_in '価格', with: ''
      click_button '更新する'
      expect(page).to have_content '変更に失敗しました。'
      visit admins_products_path
      expect(page).not_to have_content 'レタス'
    end
  end

  describe '削除' do
    it '商品を削除できる' do
      admin = create(:admin)
      product = create(:product, name: 'トマト')
      sign_in admin
      visit admins_product_path(product)
      expect(page).to have_content 'トマト'
      accept_confirm do
        click_button 'この商品を削除する'
      end
      expect(page).to have_content '削除が完了しました。'
      expect(page).not_to have_link 'トマト'
    end
  end

  describe '表示入れかえ' do
    it '商品の表示順を入れ替えることができる' do
      admin = create(:admin)
      create(:product, name: 'トマト', position: 1)
      create(:product, name: 'レタス', position: 2)
      sign_in admin
      visit admins_products_path
      expect(page).to have_selector '.product-1', text: 'トマト'
      first('.move-lower').click
      expect(page).to have_selector '.product-1', text: 'レタス'
    end
  end
end
