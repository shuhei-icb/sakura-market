describe '注文' do
  describe '作成' do
    it 'カートに入れた商品を注文できる' do
      user = create(:user, :confirmed, :with_cart)
      create(:cart_item, cart: user.cart, product: create(:product, name: 'トマト', price: 198))
      create(:cart_item, cart: user.cart, product: create(:product, name: 'レタス', price: 298))
      sign_in user
      visit carts_path
      click_link 'レジに進む'
      expect(page).to have_content 'ご注文商品の確認'
      expect(page).to have_content 'トマト'
      expect(page).to have_content 'レタス'
      expect(page).to have_content '1,534円'
      click_button '注文を確定する'
      expect(page).to have_content '注文が完了しました。'
      expect(page).to have_content 'カートに商品は入っていません。'
    end

    it '２つのタブで操作した場合、注文確認画面に表示されている商品のみ注文される' do
      product = create(:product, :published, name: 'トマト')
      another_product = create(:product, :published, name: 'レタス')
      user = create(:user, :confirmed)
      sign_in user

      # タブ1でトマトをカートに追加しレジに進む
      visit product_path(product)
      click_button 'カートに入れる'
      expect(page).to have_content 'カートに追加しました。'
      visit carts_path
      click_link 'レジに進む'
      expect(page).to have_content 'ご注文商品の確認'
      expect(page).to have_content 'トマト'

      # タブ2でレタスをカートに追加しレジに進む
      page.within_window(page.open_new_window) do
        visit product_path(another_product)
        click_button 'カートに入れる'
        expect(page).to have_content 'カートに追加しました。'
        visit carts_path
        click_link 'レジに進む'
        expect(page).to have_content 'ご注文商品の確認'
        expect(page).to have_content 'トマト'
        expect(page).to have_content 'レタス'
      end

      # タブ1でトマトの注文を確定する
      click_button '注文を確定する'
      expect(page).to have_content '注文が完了しました。'

      # トマトのみ注文される
      expect(page).to have_content 'カートに入っている商品'
      expect(page).not_to have_content 'トマト'
      expect(OrderItem.exists?(product_id: product.id)).to be true
      expect(page).to have_content 'レタス'
      expect(OrderItem.exists?(product_id: another_product.id)).to be false
    end

    it '2つのタブで注文操作した場合、重複して商品が注文されない' do
      product = create(:product, :published, name: 'トマト')
      user = create(:user, :confirmed)
      sign_in user

      # タブ1でトマトをカートに追加しレジに進む
      visit product_path(product)
      click_button 'カートに入れる'
      expect(page).to have_content 'カートに追加しました。'
      visit carts_path
      click_link 'レジに進む'
      expect(page).to have_content 'ご注文商品の確認'
      expect(page).to have_content 'トマト'

      # タブ2でトマトの注文を確定する
      page.within_window(page.open_new_window) do
        visit users_orders_path
        click_button '注文を確定する'
        expect(page).to have_content '注文が完了しました。'
      end

      # タブ1でトマトの注文を確定するが注文されない
      click_button '注文を確定する'
      expect(page).to have_content 'カート内に注文済み商品が含まれていたため、注文はキャンセルされました。'
      expect(page).to have_content 'カートに商品は入っていません。'
    end

    it 'カートに商品を追加後、商品の金額が変更された場合、注文されない' do
      # ユーザーは198円+税の商品をカートに追加
      user = create(:user, :confirmed, :with_cart)
      product = create(:product, name: 'トマト', price: 198)
      create(:cart_item, cart: user.cart, product:)
      sign_in user
      visit users_orders_path

      # 管理者が商品を298円に値上げ
      product.update!(price: 298)

      # ユーザーは198円+税のまま注文を確定する
      expect(page).to have_content 'ご注文商品の確認'
      expect(page).to have_content 'トマト'
      expect(page).to have_content '217円'
      click_button '注文を確定する'

      # 注文されず、金額が修正される
      expect(page).to have_content 'カート内商品の金額が変更されたので、注文はキャンセルされました。'
      expect(page).to have_content 'カートに入っている商品'
      expect(page).to have_content 'トマト'
      expect(page).to have_content '327円'
    end
  end
end
