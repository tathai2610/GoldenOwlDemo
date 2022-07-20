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
      resources :user_addresses
    end
  end

  resource :cart
  resources :orders

  resources :shops do    
    resources :products do 
      post 'import', on: :collection
    end
  end

  namespace :shop do 
    resources :orders
  end

  resources :addresses do 
    collection do 
      get '/cities/:city_id/districts', to: 'addresses#get_districts'
      get '/districts/:district_id/wards', to: 'addresses#get_wards'
    end
  end

  resources :carts do 
    resources :line_items, module: :carts do
      delete 'destroy_all', on: :collection
    end
  end

  resources :orders do 
    resources :line_items, module: :orders
  end

  resources :products, only: %i(index)
end
