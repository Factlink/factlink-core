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
    
  # Search and infinite scrolling
  match "/search(/page/:page)(/:sort/:direction)" => "facts#search", :as => "factlink_overview"  
  match "/client_search(/page/:page)(/:sort/:direction)" => "facts#client_search", :as => "client_search"
  
  ##########
  # Javascript Client calls
  get   "/site/count" => "sites#facts_count_for_url"  
  get   "/site" => "sites#facts_for_url"  # Now defined in factlink controller

  # Prepare a new Fact
  match "/factlink/prepare/new" => "facts#prepare_new"
  match "/factlink/prepare/evidence" => "facts#prepare_evidence"
  match "/factlink/intermediate" => "facts#intermediate"
  
  match "/factlink/new" => "facts#create"  
  match "/factlink/show/:id"  => "facts#show", :as => "factlink"
  get   "/factlink/:id/edit"  => "facts#edit", :as => "edit_factlink"

  # Add evidence as supporting or weakening
  get   "/factlink/:fact_id/add_supporting_evidence/:evidence_id"  => "facts#add_supporting_evidence",  :as => "add_supporting_evidence"
  get   "/factlink/:fact_id/add_weakening_evidence/:evidence_id"   => "facts#add_weakening_evidence",   :as => "add_weakening_evidence"

  # Create new facts as evidence (supporting or weakening)
  get   "/factlink/:fact_id/add_supporting_evidence/"  => "facts#create_fact_as_supporting_evidence",  :as => "create_fact_as_supporting_evidence"
  get   "/factlink/:fact_id/add_weakening_evidence/"   => "facts#create_fact_as_weakening_evidence",   :as => "create_fact_as_weakening_evidence"  
  
  # Not used anymore ?
  get   "/factlink/:factlink_id/interacting_users" => "facts#interaction_users_for_factlink", :as => "interacting_users"

  # Set opinion on a Fact
  get   "/fact/:fact_relation_id/opinion/:type" => "facts#toggle_opinion_on_fact", :as => "opinion"

  # Set relevance of a FactRelation
  get   "/fact_relation/:fact_relation_id/:type" => "facts#toggle_relevance_on_fact_relation", :as => "relevance"
  
  # Template shown when user hovers a Fact
  get "/factlink/indication" => "facts#indication"
  
  ##########
  # Web Front-end
  root :to => "home#index"
  get "/:username" => "users#show", :as => "user_profile"
  
  match "/topic/:search" => "home#index", :as => "search_topic"  

end