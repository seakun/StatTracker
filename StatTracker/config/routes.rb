StatTracker::Application.routes.draw do
  resources :teams

  resources :players

  resources :pitching_stats

  resources :pitching_post_stats

  resources :franchises

  resources :leagues

  resources :fielding_stats

  resources :fielding_post_stats

  resources :divisions

  resources :batting_stats

  resources :batting_post_stats
  
  match 'sort/season/batting' => 'batting_stats#single_season'
  match 'sort/season/batting_post' => 'batting_post_stats#single_season'
  match 'sort/season/pitching' => 'pitching_stats#single_season'
  match 'sort/season/pitching_post' => 'pitching_post_stats#single_season'
  match 'sort/season/fielding' => 'fielding_stats#single_season'
  match 'sort/season/fielding_post' => 'fielding_post_stats#single_season'
  
  match 'sort/career/batting' => 'batting_stats#career'
  match 'sort/career/pitching_post' => 'pitching_post_stats#career'

  match 'sort/active/batting' => 'batting_stats#active'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
