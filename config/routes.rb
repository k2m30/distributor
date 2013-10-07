Distibutor::Application.routes.draw do
  resources :settings

  resources :items do
    collection do
      get 'refine_items' => 'items#refine_items'
    end
  end

  resources :urls do
  member do
    get 'test_regexp' => 'urls#test_regexp'
  end
  collection do
    get 'update_prices' => 'urls#update_prices'
    get 'update_violators' => 'urls#update_violators'
    get 'find_urls' => 'urls#find_urls'
  end
  end

  resources :sites do
    collection do
      get 'stoplist' => 'sites#stop_list'
      get 'export' => 'sites#export'
      get 'import' => 'sites#import'
    end

  end


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
