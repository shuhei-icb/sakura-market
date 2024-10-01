class TopController < ApplicationController
  def index
    @products = Product.published.with_attached_image.default_order
  end
end
