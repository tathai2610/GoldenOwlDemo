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
    resource :cart
    resource :shop
    resources :user_infos
    resources :orders

    collection do
      resources :user_addresses
    end
  end

  resources :user_infos do 
    resources :addresses
  end
  
  resources :shops do
    resource :address
    resources :products do 
      post 'import', on: :collection
    end

    collection do
      resource :shop_registration
    end
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
