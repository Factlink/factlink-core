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
  resources :facts, :except => [:edit, :index] do
    
    resources :evidence
    resources :supporting_evidence
    resources :weakening_evidence
    
    member do
      # TODO Refactor to use this opinion routes
      # get   "/opinions" => "facts#opinions", :as => "fact_opinions"
      match "/evidence_search(/page/:page)(/:sort/:direction)" => "facts#evidence_search", :as => "evidence_search"
      get "/channels" => "facts#get_channel_listing"
      
      get     "opinion" => "facts#opinion"
      post    "opinion/:type" => "facts#set_opinion", :as => "set_opinion"
      delete  "opinion/" => "facts#remove_opinions", :as => "delete_opinion"
    end
    collection do
      #SHOULD be replaced with a PUT to a fact, let the jeditable post to a function instead of to a url
      #       the function should be able to use the json response of the put
      post  "/update_title" => "facts#update_title", :as => "update_title"
    end
    
    #TODO: is this still needed?
    resources :fact_relations
  end 
  
  ###############
  # Sites Controller
  ##########
  # Javascript Client calls
  # TODO: replace /site/ gets with scoped '/sites/', and make it a resource (even if it only has show)
  get   "/site/count" => "sites#facts_count_for_url"  
  get   "/site" => "sites#facts_for_url" 
  get   "/site/:id" => "sites#show"

  ################
  # OTHER
  ###############

  # Static js micro templates
  get "/templates/:name" => "templates#show", constraints: { name: /[-a-zA-Z_]+/ }

  # Search and infinite scrolling
  match "/search(/page/:page)(/:sort/:direction)" => "home#search", :as => "factlink_overview" 

  # generate the images for the indicator used in the js-lib
  get "/images/wheel/:percentages" => "wheel#show", constraints: { percentages: /[0-9]+-[0-9]+-[0-9]+/ }

  ##########
  # Web Front-end
  root :to => "home#index"
  get "tos" => "tos#show", as: "tos"
  post "tos" => "tos#update", as: "tos"

  get "/pages/:name" => "home#pages", constraints: { name: /[-a-zA-Z_]+/ }, :as => "pages"
  get "/tour" => "home#tour", as: "tour"


  namespace :admin do
    resources :users
  end

  scope "/:username" do
    get "/" => "users#show", :as => "user_profile"

    resources :channels do
      collection do
        post "toggle/fact" => "channels#toggle_fact",  :as => "toggle_fact"
      end

      member do 
        resources :subchannels do
          collection do
            post "add/:subchannel_id/", :as => "add", :action => "add"
            post "remove/:subchannel_id/", :as => "remove", :action => "remove"
          end
        end
        
        # TODO replace with collection do add:
        get "follow", :as => "follow"
        
        get "related_users", :as => "channel_related_users"
        get "activities", :as => "activities"
        
        post "toggle/fact/:fact_id/" => "channels#toggle_fact"
        
        post "add/:fact_id" => "channels#add_fact"
        post "remove/:fact_id" => "channels#remove_fact"

        scope "/facts" do
          get "/" => "channels#facts", :as => "get_facts_for"
          delete "/:fact_id/" => "channels#remove_fact",  :as => "remove_fact_from"
        end
      end
    end
  end


  ##################
  # SOON TO DEPRECATE ROUTES (move to restful resources):
  ##################
  
  # Prepare a new Fact
  match "/factlink/intermediate" => "facts#intermediate"

  ################
  # FactRelation Controller
  ################

  # Add evidence as supporting or weakening
  post  "/factlink/:id/add_supporting_evidence/:evidence_id"  => "facts#add_supporting_evidence",  :as => "add_supporting_evidence"
  post  "/factlink/:id/add_weakening_evidence/:evidence_id"   => "facts#add_weakening_evidence",   :as => "add_weakening_evidence"

  
  # Create new facts as evidence (supporting or weakening)
  get   "/factlink/create_evidence/"  => "facts#create_fact_as_evidence",  :as => "create_fact_as_evidence"
  get   "/factlink/add_evidence/"  => "facts#add_new_evidence",  :as => "add_evidence"
  


end
