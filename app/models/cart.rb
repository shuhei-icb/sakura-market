class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  delegate :include?, to: :products

  def has_ordered_products?(products)
    products.any? { |product| self.user.ordered?(product) }
  end
end
