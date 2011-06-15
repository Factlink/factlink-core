FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  ### Development
  get "/signed_in" => "dev#login_test"
  get "/iframe" => "dev#iframe"
  get "/needs_sign_in" => "dev#needs_sign_in"

  get "/iframe2" => "dev#iframe2"

  get "/the_form" => "dev#the_form"
  post "/post_form" => "dev#post_form"

  ##########
  # User Authentication
  devise_for :admins
  devise_for :users, :controllers => {  :registrations => "users/registrations",
                                        :sessions => "users/sessions" }

  resource :sites
  
  ##########
  # Javascript Client calls
  get "/site" => "sites#highlights_for_site"
  get "/site/count" => "sites#count_for_site"

  ##########
  # Factlink Tops
  match "/factlink/prepare" => "factlink_tops#prepare"
  match "/factlink/intermediate/(:the_action)/(:id)" => "factlink_tops#intermediate"
  
  match "/factlink/new" => "factlink_tops#create"  
  match "/factlink/show/:id" => "factlink_tops#show", :as => "factlink"
  match "/factlink/:id/edit" => "factlink_tops#edit", :as => "edit_factlink"
  match "/factlink(/page/:page)(/:sort/:direction)" => "factlink_tops#index"
  # match "/factlink/search" => "factlink_tops#search", :as => "factlink_search"

  ##########
  # Factlink Subs
  match "/factlink/addtag/:id" => "factlink_subs#add_tag"
  # up and down voting
  get "/factlink_subs/:id/vote/up" => "factlink_subs#vote_up",      :as => "factlink_sub_vote_up"
  get "/factlink_subs/:id/vote/down" => "factlink_subs#vote_down",  :as => "factlink_sub_vote_down"

  ##########
  # Factlink resources
  resources :factlink_tops
  resources :factlink_subs
  
  ##########
  # Web Front-end
  root :to => "home#index"
  
  match "/topic/:search" => "home#index", :as => "search_topic"  

  ##########
  # Development, testing Solr
  # match "/search" => "factlink_tops#search"

  ##########
  # User actions
  get "/:username" => "users#show"


  ##########
  # Old, getting deprecated
  match "/factlinks_for_url" => "sites#highlights_for_site"
  match "/factlink_subs_for_factlink_id" => "sites#count_for_site"

  

  ############################################################################
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  #
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  #
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  #
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
  #
  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  #
  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end
  #
  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  #
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  #
  # See how all your routes lay out with "rake routes"
  #
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
