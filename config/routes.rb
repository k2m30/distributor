Distibutor::Application.routes.draw do
  get "main/index"

  resources :logs, only: [:index, :destroy] do
    collection do
      get 'clear_log' => 'logs#clear_log'
    end
  end

  resources :settings, only: [:index, :show, :edit, :update] do
    collection do
      post 'import_preview' => 'settings#import_standard_prices_preview'
      get 'import_standard_prices' => 'settings#import_standard_prices'

      post 'all' => 'settings#all_sites_preview'
      get 'all' => 'settings#all_sites_import'

      post 'import_shops_preview' => 'settings#import_user_sites_preview'
      get 'import_shops' => 'settings#import_user_sites'

      get 'export_shops_preview' => 'settings#export_shops_preview'
      get 'export_shops' => 'settings#export_shops'
    end
  end

  resources :items, only: [:index, :show] do
    collection do
      get 'refine_items' => 'items#refine_items'
    end
  end

  resources :urls, only: [:index] do
    member do
      get 'upd' => 'urls#update_single_price'
    end
    collection do
      get 'update_prices' => 'urls#update_prices'
      get 'update_violators' => 'urls#update_violators'
      get 'find_urls' => 'urls#find_urls'
    end
  end

  resources :sites, only: [:index, :show, :edit, :update, :new] do
    collection do
      get 'stop_list' => 'sites#stop_list'
      get 'search' => 'sites#search'
    end

    member do
      get 'logs' => 'sites#logs'
      get 'logs_submit' => 'sites#logs_submit'
    end

  end

  get '/dj' => DelayedJobWeb, :anchor => false

  resources :groups, only: [:show]

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

end
