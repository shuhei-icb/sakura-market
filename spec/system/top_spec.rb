RSpec.describe 'トップページ' do
  describe '一覧' do
    it '商品の一覧が表示される' do
      create(:product, :published, name: 'トマト', price: 100, image: fixture_file_upload('spec/fixtures/tomato-image.jpg'))
      create(:product, :published, name: 'レタス', price: 300)
      create(:product, name: 'キャベツ', published: false)
      visit root_path
      expect(page).to have_content 'トマト'
      expect(page).to have_content '110円'
      expect(page).to have_selector("img[src$='tomato-image.jpg']")
      expect(page).to have_content 'レタス'
      expect(page).to have_content '330円'
      expect(page).not_to have_content 'キャベツ'
    end
  end
end
