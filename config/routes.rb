Rails.application.routes.draw do
  root 'top#index'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  namespace :admins do
    root 'top#index'
  end
end
