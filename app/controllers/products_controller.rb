class ProductsController < ApplicationController
  def show
    @product = Product.published.find(params[:id])
  end
end
