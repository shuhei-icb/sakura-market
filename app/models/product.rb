class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price,
            presence: true,
            numericality: { greater_than: 0 }

  scope :default_order, -> { order(:position, :id) }
  acts_as_list
end
