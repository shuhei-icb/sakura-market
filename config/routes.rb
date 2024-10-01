Rails.application.routes.draw do
  root 'top#index'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  resource :my_page, only: :show, module: :users
  resources :products, only: :show

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

  namespace :users do
    resource :orders, only: %i[show create]
    resources :order_items, only: :index
  end

  resource :carts, only: :show do
    resources :cart_items, only: %i[create destroy], module: :carts
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
