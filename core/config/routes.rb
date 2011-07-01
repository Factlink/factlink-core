FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  ##########
  # User Authentication
  devise_for :admins
  devise_for :users, :controllers => {  :registrations => "users/registrations",
                                        :sessions => "users/sessions" }
  
  ##########
  # Resources
  resources :factlinks
  
  # get "factlink_overview"
  
  
  # Search and infinite scrolling
  match "/search(/page/:page)(/:sort/:direction)" => "factlinks#search", :as => "factlink_overview"
  
  
  ##########
  # Javascript Client calls
  get   "/site/count" => "sites#count_for_site"
  get   "/site" => "factlinks#factlinks_for_url"  # Now defined in factlink controller

  # Prepare a new Factlink
  match "/factlink/prepare" => "factlinks#prepare"
  match "/factlink/intermediate/(:the_action)/(:id)" => "factlinks#intermediate"
  
  match "/factlink/new" => "factlinks#create"  
  match "/factlink/show/:id"  => "factlinks#show", :as => "factlink"
  get   "/factlink/:id/edit"  => "factlinks#edit", :as => "edit_factlink"


  
  # Add a Factlink as source

  get   "/factlink/:factlink_id/add_existing_source/:source_id" => "factlinks#add_source_to_factlink", :as => "add_source_to_factlink"
  
  # get   "/factlink/:factlink_id/add_to_parent/:parent_id"       => "factlinks#add_factlink_to_parent", :as => "add_factlink_to_parent"


  get   "/factlink/:factlink_id/add_to_parent_as_supporting/:parent_id" => "factlinks#add_factlink_to_parent_as_supporting",  :as => "add_factlink_to_parent_as_supporting"
  get   "/factlink/:factlink_id/add_to_parent_as_weakening/:parent_id"  => "factlinks#add_factlink_to_parent_as_weakening",   :as => "add_factlink_to_parent_as_weakening"

  get   "/factlink/:factlink_id/remove_from_parent/:parent_id"  => "factlinks#remove_factlink_from_parent", :as => "remove_factlink_from_parent"

  # Adding sources as supporting or weakening
  get   "/factlink/:factlink_id/add_source_as_supporting/:source_id"  => "factlinks#add_source_as_supporting",  :as => "add_supporting_source_to_factlink"
  get   "/factlink/:factlink_id/add_source_as_weakening/:source_id"   => "factlinks#add_source_as_weakening",   :as => "add_weakening_source_to_factlink"

  get   "/factlink/:factlink_id/interacting_users" => "factlinks#interaction_users_for_factlink", :as => "interacting_users"

  # Believe, doubt and disbelieve
  get "/factlink/:id/believe"     => "factlinks#believe",    :as => "believe"
  get "/factlink/:id/doubt"       => "factlinks#doubt",      :as => "doubt"
  get "/factlink/:id/disbelieve"  => "factlinks#disbelieve", :as => "disbelieve"

  # Set opinion and relevance
  get "/factlink/:child_id/opinion/:type/:parent_id" => "factlinks#set_opinion", :as => "opinion"
  get "/factlink/:child_id/relevance/:type/:parent_id" => "factlinks#set_relevance", :as => "relevance"
  
  ##########
  # Web Front-end
  root :to => "home#index"
  get "/:username" => "users#show", :as => "user_profile"
  
  
  match "/topic/:search" => "home#index", :as => "search_topic"  


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
