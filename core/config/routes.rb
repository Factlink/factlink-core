FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # development
  get "new" => "home#new"


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
  get   "/site" => "sites#facts_for_url" 
  
  # Prepare a new Fact
  match "/factlink/prepare/new" => "facts#prepare_new"
  match "/factlink/prepare/evidence" => "facts#prepare_evidence"
  match "/factlink/intermediate" => "facts#intermediate"
  
  post "/factlink/create" => "facts#create"  
  match "/factlink/show/:id"  => "facts#show", :as => "factlink"
  get   "/factlink/:id/edit"  => "facts#edit", :as => "edit_factlink"

  # Add evidence as supporting or weakening
  get   "/factlink/:fact_id/add_supporting_evidence/:evidence_id"  => "facts#add_supporting_evidence",  :as => "add_supporting_evidence"
  get   "/factlink/:fact_id/add_weakening_evidence/:evidence_id"   => "facts#add_weakening_evidence",   :as => "add_weakening_evidence"
  
  # Create new facts as evidence (supporting or weakening)
  get   "/factlink/create_evidence/"  => "facts#create_fact_as_evidence",  :as => "create_fact_as_evidence"
  get   "/factlink/add_evidence/"  => "facts#add_new_evidence",  :as => "add_evidence"

  # Set opinion on a Fact
  get   "/fact/:fact_relation_id/opinion/:type" => "facts#toggle_opinion_on_fact", :as => "opinion"

  # Set relevance of a FactRelation
  get   "/fact_relation/:fact_relation_id/:type" => "facts#toggle_relevance_on_fact_relation", :as => "relevance"
  
  # Template shown when user hovers a Fact
  get "/factlink/indication" => "facts#indication"
  
  ##########
  # Web Front-end
  root :to => "home#index"

  # get "/:username" => "users#show", :as => "user_profile"
  
  scope "/:username" do

    post "/channels/add_fact"    => "channels#add_fact",     :as => "add_fact_to_channel"
    post "/channels/toggle/fact" => "channels#toggle_fact",  :as => "toggle_fact"

    get "/channels/:channel_id/remove_fact/:fact_id" => "channels#remove_fact",  :as => "remove_fact_from_channel"



    get "/" => "users#show", :as => "user_profile"
    resources :channels    
    post "/channels/:id" => "channels#update"

  end
  
  match "/topic/:search" => "home#index", :as => "search_topic"  

end