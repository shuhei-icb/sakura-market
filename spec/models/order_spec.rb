describe Order do
  describe '#confirm_order' do
    it '注文が完了する' do
      user = create(:user, :confirmed, :with_cart)
      create(:cart_item, cart: user.cart, product: create(:product, name: 'トマト', price: 198))
      create(:cart_item, cart: user.cart, product: create(:product, name: 'レタス', price: 298))
      expect do
        Order.confirm_order(user.cart, user.cart.products, 544, 330, 660)
      end.to change(Order, :count).by(1).and change(OrderItem, :count).by(2).and change(CartItem, :count).by(-2)
    end
  end

  describe '#taxed_cash_on_delivery' do
    it '代引き手数料が正しく計算される' do
      expect(Order.taxed_cash_on_delivery(9_999)).to eq 330
      expect(Order.taxed_cash_on_delivery(29_999)).to eq 440
      expect(Order.taxed_cash_on_delivery(99_999)).to eq 660
      expect(Order.taxed_cash_on_delivery(999_999)).to eq 1_100
    end
  end

  describe '#taxed_shipping_fee' do
    it '送料が正しく計算される' do
      expect(Order.taxed_shipping_fee(5)).to eq 660
      expect(Order.taxed_shipping_fee(10)).to eq 1_320
      expect(Order.taxed_shipping_fee(15)).to eq 1_980
      expect(Order.taxed_shipping_fee(20)).to eq 2_640
    end
  end
end
