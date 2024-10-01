describe Product do
  describe '#price_including_tax' do
    it '消費税が10%課税される' do
      product = create(:product, price: 100)
      expect(product.price_including_tax).to eq 110
    end

    it '小数点以下は切り捨てされる' do
      product = create(:product, price: 198)
      expect(product.price_including_tax).to eq 217
    end
  end
end
