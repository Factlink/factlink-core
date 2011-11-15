FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  ##########
  # User Authentication
  devise_for :users, :controllers => {  :registrations => "users/registrations",
                                        :sessions => "users/sessions" }

  ################
  # Facts Controller
  ################
  resources :facts do
    member do
      # TODO Refactor to use this opinion routes
      # get   "/opinions" => "facts#opinions", :as => "fact_opinions"
      match "/evidence_search(/page/:page)(/:sort/:direction)" => "facts#evidence_search", :as => "evidence_search"
      get "/channels" => "facts#get_channel_listing"
    end
    
    resources :fact_relations
  end 
  

  #SHOULD be replaced with a PUT to a fact, let the jeditable post to a function instead of to a url
  #       the function should be able to use the json response of the put
  post  "/factlink/update_title" => "facts#update_title", :as => "update_title"
  
  # Prepare a new Fact
  match "/factlink/intermediate" => "facts#intermediate"

  # Opinion on a Fact or FactRelation  
  get     "/fact_item/:id/opinion" => "facts#opinion"
  post    "/fact_item/:fact_id/opinion/:type" => "facts#set_opinion", :as => "set_opinion"
  delete  "/fact_item/:fact_id/opinion/" => "facts#remove_opinions", :as => "delete_opinion"


  ################
  # FactRelation Controller
  ################

  # Add evidence as supporting or weakening
  post  "/factlink/:fact_id/add_supporting_evidence/:evidence_id"  => "facts#add_supporting_evidence",  :as => "add_supporting_evidence"
  post  "/factlink/:fact_id/add_weakening_evidence/:evidence_id"   => "facts#add_weakening_evidence",   :as => "add_weakening_evidence"

  
  # Create new facts as evidence (supporting or weakening)
  get   "/factlink/create_evidence/"  => "facts#create_fact_as_evidence",  :as => "create_fact_as_evidence"
  get   "/factlink/add_evidence/"  => "facts#add_new_evidence",  :as => "add_evidence"


  ###############
  # Sites Controller
  ##########
  # Javascript Client calls
  # TODO: probably better as sites/facts (with subresources)
  get   "/site/count" => "sites#facts_count_for_url"  
  get   "/site" => "sites#facts_for_url" 
  get   "/site/:id" => "sites#show"
  
  scope "/sites" do
    scope "/:url", :constraints => { :url => /.*/ } do
      get "/info" => "sites#facts_count_for_url"
      
      resources "facts"
    end
  end

  ################
  # OTHER
  ###############

  # Static js micro templates
  get "/templates/:name" => "templates#get"

  # Search and infinite scrolling
  match "/search(/page/:page)(/:sort/:direction)" => "home#search", :as => "factlink_overview" 
    
  
  
  match "/topic/:search" => "home#index", :as => "search_topic"  


  # generate the images for the indicator used in the js-lib
  get "/images/wheel/:percentages" => "wheel#show", :constraints => {:percentages => /[0-9]+-[0-9]+-[0-9]+/}

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
        get "related_users", :as => "channel_related_users"
        post "toggle/fact/:fact_id/" => "channels#toggle_fact"

        scope "/facts" do
          get "/" => "channels#facts", :as => "get_facts_for"
          delete "/:fact_id/" => "channels#remove_fact",  :as => "remove_fact_from"
        end
      end
    end
    
    get "/activities" => "users#activities", :as => "user_activities"
  end
  

end
