Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root "home#index"

  resources :users do
    resource :shop
  end
  
  resources :shop do
    resources :products
  end

  resources :products, only: %i(index)
end
