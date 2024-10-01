class Users::OrderItemsController < Users::ApplicationController
  def index
    @order_items = current_user.order_items.preload(:order, product: { image_attachment: :blob }).order_by_latest
  end
end
