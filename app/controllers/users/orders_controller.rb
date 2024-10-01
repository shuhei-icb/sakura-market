class Users::OrdersController < Users::ApplicationController
  def show
    @cart_items = current_cart.cart_items.preload(product: { image_attachment: :blob }).order_by_latest
  end

  def create
    products = Product.where(id: params[:product_ids])
    total_price, payment_amount, cash_on_delivery, shipping_fee = params.values_at(:total_price, :payment_amount, :cash_on_delivery, :shipping_fee).map(&:to_i)
    if current_cart.has_ordered_products?(products)
      flash[:error] = 'カート内に注文済み商品が含まれていたため、注文はキャンセルされました。'
    elsif !products.price_correct?(total_price)
      flash[:error] = 'カート内商品の金額が変更されたので、注文はキャンセルされました。'
    else
      Order.confirm_order(current_cart, products, payment_amount, cash_on_delivery, shipping_fee)
      flash[:notice] = '注文が完了しました。'
    end
    redirect_to carts_path
  end
end
