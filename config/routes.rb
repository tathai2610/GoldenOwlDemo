Rails.application.routes.draw do
  devise_for :users

  namespace :admin do 
    root "dashboard#index"
    resources :dashboard
  end

  root "home#index"

  resources :users do
    resource :shop
  end
  
  resources :shops do
    resources :products do 
      post 'import', on: :collection
    end
  end

  resources :products, only: %i(index)
end
