class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :registerable, :rememberable, :confirmable

  has_one :cart, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  scope :default_order, -> { order(:id) }
end
