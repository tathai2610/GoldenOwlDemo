Rails.application.routes.draw do
  devise_for :users

  namespace :admin do 
    root "dashboard#index"
    resources :dashboard
    get '/shops/pendings', to: 'dashboard#pending_shops'
    put '/shops/:shop_id/handle', to: 'dashboard#handle_shop', as: '/handle_shop'
  end

  root "home#index"

  resources :users do
    resource :shop
    collection do
      resources :cart_items
      delete '/cart_items/destroy_all', to: 'cart_items#destroy_all'
    end
  end
  
  resources :shops do
    resources :products do 
      post 'import', on: :collection
    end
  end

  resources :products, only: %i(index)
end
