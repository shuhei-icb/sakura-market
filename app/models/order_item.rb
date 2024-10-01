class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :order_id, uniqueness: { scope: :product_id }

  scope :order_by_latest, -> { order(created_at: :desc) }
end
