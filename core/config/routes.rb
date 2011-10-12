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
  # match "/search(/page/:page)(/:sort/:direction)" => "facts#search", :as => "factlink_overview"
  
  match "/search(/page/:page)(/:sort/:direction)" => "home#search", :as => "factlink_overview" 
  match "/evidence_search(/page/:page)(/:sort/:direction)" => "facts#evidence_search", :as => "evidence_search"
  match "/evidenced_search(/page/:page)(/:sort/:direction)" => "facts#evidenced_search", :as => "evidenced_search"
    
  ##########
  # Javascript Client calls
  get   "/site/count" => "sites#facts_count_for_url"  
  get   "/site" => "sites#facts_for_url" 
  
  # Prepare a new Fact
  match "/factlink/prepare/new" => "facts#prepare_new"
  match "/factlink/prepare/evidence" => "facts#prepare_evidence"
  match "/factlink/intermediate" => "facts#intermediate"
  
  post  "/factlink/create" => "facts#create", :as => "create_factlink"
  post  "/factlink/update_title" => "facts#update_title", :as => "update_title"
  match "/factlink/show/:id"  => "facts#show", :as => "factlink"
  get   "/factlink/:id/edit"  => "facts#edit", :as => "edit_factlink"

  # Add evidence as supporting or weakening
  post   "/factlink/:fact_id/add_supporting_evidence/:evidence_id"  => "facts#add_supporting_evidence",  :as => "add_supporting_evidence"
  post   "/factlink/:fact_id/add_weakening_evidence/:evidence_id"   => "facts#add_weakening_evidence",   :as => "add_weakening_evidence"

  get   "/factlink/:fact_id/add_supporting_evidenced/:evidence_id"  => "facts#add_supporting_evidenced",  :as => "add_supporting_evidenced"
  get   "/factlink/:fact_id/add_weakening_evidenced/:evidence_id"   => "facts#add_weakening_evidenced",   :as => "add_weakening_evidenced"
  
  # Create new facts as evidence (supporting or weakening)
  get   "/factlink/create_evidence/"  => "facts#create_fact_as_evidence",  :as => "create_fact_as_evidence"
  get   "/factlink/add_evidence/"  => "facts#add_new_evidence",  :as => "add_evidence"

  # Opinion on a Fact or FactRelation  
  get     "/fact_item/:id/opinion" => "facts#opinion"
  post    "/fact_item/:fact_id/opinion/:type" => "facts#set_opinion", :as => "set_opinion"
  delete  "/fact_item/:fact_id/opinion/" => "facts#remove_opinions", :as => "delete_opinion"

  # Template shown when user hovers a Fact
  get "/factlink/indication" => "facts#indication"
  
  # Fact bubble
  # delete "/fact/:id" => "facts#destroy", :as => "fact"
  
  
  ##########
  # Web Front-end
  root :to => "home#index"

  # get "/:username" => "users#show", :as => "user_profile"
  
  scope "/:username" do
    get "/" => "users#show", :as => "user_profile"

    resources :channels do
      collection do
        post "toggle/fact" => "channels#toggle_fact",  :as => "toggle_fact"
      end

      member do 
        get "follow", :as => "follow"

        scope "/facts" do
          get "/" => "channels#facts", :as => "get_facts_for"
          delete "/:fact_id/" => "channels#remove_fact",  :as => "remove_fact_from"
        end
      end
    end
    
    get "/activities" => "users#activities", :as => "user_activities"
  end
  
  match "/topic/:search" => "home#index", :as => "search_topic"  

end