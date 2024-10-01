# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/users/application'
  before_action :configure_sign_up_params, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address])
  end
end
