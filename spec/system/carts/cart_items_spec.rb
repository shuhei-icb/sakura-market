describe 'カート内商品' do
  describe '追加' do
    it '商品をカートに追加できる' do
      user = create(:user, :confirmed)
      create(:product, :published, name: 'トマト', price: 100, image: fixture_file_upload('spec/fixtures/tomato-image.jpg'))
      sign_in user
      visit root_path
      expect(page).to have_content 'トマト'
      click_link 'トマト'
      expect(page).to have_button 'カートに入れる'
      click_button 'カートに入れる'
      expect(page).to have_content 'カートに追加しました。'
      visit carts_path
      expect(page).to have_content 'カートに入っている商品'
      expect(page).to have_selector("img[src$='tomato-image.jpg']")
      expect(page).to have_selector '.name', text: 'トマト'
      expect(page).to have_selector '.price', text: '110円'
    end

    it '同じ商品はカートに追加できない' do
      user = create(:user, :confirmed)
      product = create(:product, :published)
      sign_in user
      visit product_path(product)
      click_button 'カートに入れる'
      expect(page).to have_content 'カートに追加しました。'
      visit product_path(product)
      expect(page).to have_button 'カートに追加されています'
    end

    it '2つのタブでカートに追加する操作をした場合、同じ商品を追加できない' do
      user = create(:user, :confirmed)
      product = create(:product, :published)
      sign_in user
      visit product_path(product)

      page.within_window(page.open_new_window) do
        visit product_path(product)
        click_button 'カートに入れる'
        expect(page).to have_content 'カートに追加しました。'
        page.current_window.close
      end
      click_button 'カートに入れる'
      expect(page).to have_content 'カートにすでに同じ商品が入っています'
    end
  end

  describe '削除' do
    it '削除を押下後、カートから商品が削除される' do
      product = create(:product, :published, name: 'トマト')
      user = create(:user, :confirmed)
      cart = create(:cart, user:)
      create(:cart_item, cart:, product:)
      sign_in user
      visit carts_path
      expect(page).to have_content 'トマト'
      click_button '削除'
      expect(page).to have_content 'カートから削除しました。'
      expect(page).not_to have_content 'トマト'
    end
  end
end
