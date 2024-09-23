class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  def index
    @users = User.all.default_order
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), notice: '変更が完了しました。'
    else
      flash.now[:error] = '変更に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_path, status: :see_other, notice: '削除が完了しました。'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :address)
  end
end
