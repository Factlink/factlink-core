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
  resources :facts
  
  # get "factlink_overview"
  
  
  # Search and infinite scrolling
  match "/search(/page/:page)(/:sort/:direction)" => "facts#search", :as => "factlink_overview"
  
  
  ##########
  # Javascript Client calls
  get   "/site/count" => "sites#count_for_site"
  get   "/site" => "facts#factlinks_for_url"  # Now defined in factlink controller

  # Prepare a new Fact
  match "/factlink/prepare" => "facts#prepare"
  match "/factlink/intermediate/(:the_action)/(:id)" => "facts#intermediate"
  
  match "/factlink/new" => "facts#create"  
  match "/factlink/show/:id"  => "facts#show", :as => "factlink"
  get   "/factlink/:id/edit"  => "facts#edit", :as => "edit_factlink"


  
  # Add a Fact as source

  get   "/factlink/:factlink_id/add_existing_source/:source_id" => "facts#add_source_to_factlink", :as => "add_source_to_factlink"
  
  # get   "/factlink/:factlink_id/add_to_parent/:parent_id"       => "facts#add_factlink_to_parent", :as => "add_factlink_to_parent"


  get   "/factlink/:factlink_id/add_to_parent_as_supporting/:parent_id" => "facts#add_factlink_to_parent_as_supporting",  :as => "add_factlink_to_parent_as_supporting"
  get   "/factlink/:factlink_id/add_to_parent_as_weakening/:parent_id"  => "facts#add_factlink_to_parent_as_weakening",   :as => "add_factlink_to_parent_as_weakening"

  get   "/factlink/:factlink_id/remove_from_parent/:parent_id"  => "facts#remove_factlink_from_parent", :as => "remove_factlink_from_parent"

  # Adding sources as supporting or weakening
  get   "/factlink/:factlink_id/add_source_as_supporting/:source_id"  => "facts#add_source_as_supporting",  :as => "add_supporting_source_to_factlink"
  get   "/factlink/:factlink_id/add_source_as_weakening/:source_id"   => "facts#add_source_as_weakening",   :as => "add_weakening_source_to_factlink"

  get   "/factlink/:factlink_id/interacting_users" => "facts#interaction_users_for_factlink", :as => "interacting_users"

  # Believe, doubt and disbelieve
  get "/factlink/:id/believe"     => "facts#believe",    :as => "believe"
  get "/factlink/:id/doubt"       => "facts#doubt",      :as => "doubt"
  get "/factlink/:id/disbelieve"  => "facts#disbelieve", :as => "disbelieve"

  # Set opinion and relevance
  get "/factlink/:child_id/opinion/:type/:parent_id" => "facts#toggle_opinion", :as => "opinion"
  get "/factlink/:child_id/relevance/:type/:parent_id" => "facts#set_relevance", :as => "relevance"
  
  # Template which is shown when user hovers Fact
  get "/factlink/indication" => "facts#indication"
  
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
