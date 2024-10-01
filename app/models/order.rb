class Order < ApplicationRecord
  include Taxable

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :payment_amount, :cash_on_delivery, :shipping_fee, presence: true, numericality: { greater_than: 0 }

  scope :default_order, -> { order(:id) }

  SHIPPING_FEE_RATE = 600

  def self.confirm_order(cart, products, payment_amount, cash_on_delivery, shipping_fee)
    order = cart.user.orders.build(payment_amount:, cash_on_delivery:, shipping_fee:)
    products.each do |product|
      order.order_items.build(product:, price: product.price_including_tax)
    end
    order.save!
    cart.cart_items.where(product: products).destroy_all
  end

  def self.taxed_cash_on_delivery(price)
    base_price = case price
                 when 0...10_000
                   300
                 when 10_000...30_000
                   400
                 when 30_000...100_000
                   600
                 else
                   1_000
                 end
    Taxable.including_tax(base_price)
  end

  def self.taxed_shipping_fee(amount)
    base_price = BigDecimal((amount / 5.0).to_s).ceil * SHIPPING_FEE_RATE
    Taxable.including_tax(base_price)
  end
end
