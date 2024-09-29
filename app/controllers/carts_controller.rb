class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_cart.cart_items.preload(product: { image_attachment: :blob }).order_by_latest
  end
end
