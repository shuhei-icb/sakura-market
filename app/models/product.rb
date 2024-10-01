class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :published, -> { where(published: true) }
  scope :default_order, -> { order(:position, :id) }
  acts_as_list

  def price_including_tax
    (BigDecimal(price.to_s) * BigDecimal('1.10')).floor
  end

  def in_cart?(cart)
    cart.include?(self)
  end

  def self.price_correct?(total_price)
    taxed_price = self.pluck(:price).map { |price| Taxable.including_tax(price) }
    taxed_price.sum == total_price
  end
end
