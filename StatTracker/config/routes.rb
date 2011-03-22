StatTracker::Application.routes.draw do
  
  
  match 'home/index' => 'home#index', :as => 'home#index'
  match 'home/compare' => 'home#compare', :as => 'home#compare'
  match 'home/google' => 'search#google_images', :as => 'home#google'
  

  devise_for :users
  
  resources :users
  
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
  
  match 'users/show' => 'users#show'
  match 'leaders/season/batting/:stat' => 'batting_stats#single_season'
  match 'leaders/season/batting_post/:stat' => 'batting_post_stats#single_season'
  match 'leaders/season/pitching/:stat' => 'pitching_stats#single_season'
  match 'leaders/season/pitching_post/:stat' => 'pitching_post_stats#single_season'
  match 'leaders/season/fielding/:stat' => 'fielding_stats#single_season'
  match 'leaders/season/fielding_post/:stat' => 'fielding_post_stats#single_season'
  
  match 'leaders/career/batting/:stat' => 'batting_stats#career'
  match 'leaders/career/batting_post/:stat' => 'batting_post_stats#career'
  match 'leaders/career/pitching/:stat' => 'pitching_stats#career'
  match 'leaders/career/pitching_post/:stat' => 'pitching_post_stats#career'
  match 'leaders/career/fielding/:stat' => 'fielding_stats#career'
  match 'leaders/career/fielding_post/:stat' => 'fielding_post_stats#career'

  match 'leaders/active/batting/:stat' => 'batting_stats#active'
  match 'leaders/active/batting_post/:stat' => 'batting_post_stats#active'
  match 'leaders/active/pitching/:stat' => 'pitching_stats#active'
  match 'leaders/active/pitching_post/:stat' => 'pitching_post_stats#active'
  match 'leaders/active/fielding/:stat' => 'fielding_stats#active'
  match 'leaders/active/fielding_post/:stat' => 'fielding_post_stats#active'
  
  match 'compare/season/batting/*comp' => 'batting_stats#season_compare'
  match 'compare/career/batting/*comp' => 'batting_stats#career_compare'
  match 'compare/multi/batting/*comp' => 'batting_stats#multi_compare'
  match 'compare/season/pitching/*comp' => 'pitching_stats#season_compare'
  match 'compare/career/pitching/*comp' => 'pitching_stats#career_compare'
  match 'compare/multi/pitching/*comp' => 'pitching_stats#multi_compare'

  match 'seasonfinder/batting' => 'batting_stats#season_finder'
  match 'seasonfinder/batting/results' => 'batting_stats#find_seasons'
  
  match 'change_chart_batting' => 'batting_stats#change_chart'
  match 'change_table_batting' => 'batting_stats#change_table'
  match 'change_chart_pitching' => 'pitching_stats#change_chart'
  match 'change_table_pitching' => 'pitching_stats#change_table'
  
  match 'search' => 'home#search', :as => :search
  
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
   root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
