Distibutor::Application.routes.draw do
  resources :logs do
    collection do
      get 'clear_log' => 'logs#clear_log'
    end
  end
  resources :settings do
    collection do
      post 'import_preview' => 'settings#import_standard_prices_preview'
      get 'import_standard_prices' => 'settings#import_standard_prices'

      post 'all' => 'settings#all_sites_preview'
      get 'all' => 'settings#all_sites_import'

      post 'import_shops_preview' => 'settings#import_user_sites_preview'
      get 'import_shops' => 'settings#import_user_sites'
    end
  end

  resources :items do
    collection do
      get 'refine_items' => 'items#refine_items'
    end
  end

  resources :urls do
    member do
      get 'upd' => 'urls#update_single_price'
    end
    collection do
      get 'update_prices' => 'urls#update_prices'
      get 'update_violators' => 'urls#update_violators'
      get 'find_urls' => 'urls#find_urls'
    end
  end

  resources :sites do
    collection do
      get 'stop_list' => 'sites#stop_list'
    end

    member do
      get 'logs' => 'sites#logs'
    end

  end

  get '/dj' => DelayedJobWeb, :anchor => false

  resources :groups

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'sites#stop_list'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
