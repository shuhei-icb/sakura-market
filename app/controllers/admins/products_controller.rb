class Admins::ProductsController < Admins::ApplicationController
  before_action :set_product, only: %i[show edit update destroy move_higher move_lower]
  def index
    @products = Product.all.default_order
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admins_product_path(@product), notice: '登録が完了しました。'
    else
      flash.now[:error] = '登録に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admins_product_path(@product), notice: '変更が完了しました。'
    else
      flash.now[:error] = '変更に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to admins_products_path, status: :see_other, notice: '削除が完了しました。'
  end

  def move_higher
    @product.move_higher
    redirect_to admins_products_path
  end

  def move_lower
    @product.move_lower
    redirect_to admins_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :image, :price, :published, :position, :description)
  end
end
