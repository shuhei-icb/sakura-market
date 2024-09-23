class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  validates :name, presence: true
  validates :address, presence: true

  scope :default_order, -> { order(:id) }
end
