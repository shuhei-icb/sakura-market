class ApplicationController < ActionController::Base
  layout 'layouts/users/application'
  helper_method :current_cart

  def after_sign_in_path_for(resource)
    resource.instance_of?(Admin) ? admins_root_path : my_page_path
  end

  def after_sign_out_path_for(resource)
    resource.instance_of?(Admin) ? admins_root_path : root_path
  end

  private

  def current_cart
    @current_cart ||= current_user&.cart || current_user&.create_cart!
  end
end
