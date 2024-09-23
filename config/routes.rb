Rails.application.routes.draw do
  root 'top#index'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  namespace :admins do
    resources :products do
      member do
        get :move_higher
        get :move_lower
      end
    end
    resources :users, only: %i[index show edit update destroy]
    root 'top#index'
  end
end
