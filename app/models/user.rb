class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :registerable, :rememberable, :confirmable

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders

  validates :name, presence: true
  validates :address, presence: true

  scope :default_order, -> { order(:id) }

  def ordered?(product)
    order_items.exists?(product:)
  end
end
