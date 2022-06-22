Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :users do
    resource :shop
  end
  
  resources :shops do
    resources :products
  end

  resources :products, only: %i(index)
end
