class Carts::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @product = Product.find(params[:product_id])
    cart_item = current_cart.cart_items.build(product: @product)
    if cart_item.save
      redirect_to product_path(@product), notice: 'カートに追加しました。'
    else
      flash.now[:error] = cart_item.errors.full_messages.join("\n")
      render 'products/show', status: :unprocessable_entity
    end
  end

  def destroy
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy!
    redirect_to carts_path, status: :see_other, notice: 'カートから削除しました。'
  end
end
