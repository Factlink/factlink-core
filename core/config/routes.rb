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

    resources :supporting_evidence, :weakening_evidence do
      get     "opinion"       => "evidence#opinion"
      post    "opinion/:type" => "evidence#set_opinion", :as => "set_opinion"
      delete  "opinion/"      => "evidence#remove_opinions", :as => "delete_opinion"
    end

    member do
      post    "opinion/:type" => "facts#set_opinion", :as => "set_opinion"
      delete  "opinion/"      => "facts#remove_opinions", :as => "delete_opinion"

      match "/evidence_search" => "facts#evidence_search"

      get "/channels" => "facts#get_channel_listing"
    end
    collection do
      #SHOULD be replaced with a PUT to a fact, let the jeditable post to a function instead of to a url
      #       the function should be able to use the json response of the put
      post  "/update_title" => "facts#update_title", :as => "update_title"
    end
  end

  get "/:fact_slug/f/:id" => "facts#extended_show", as: "frurl_fact"

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
  get "/system/wheel/:percentages" => "wheel#show", constraints: { percentages: /[0-9]+-[0-9]+-[0-9]+/ }

  ##########
  # Web Front-end
  root :to => "home#index"

  get "tos" => "tos#show", as: "tos"
  post "tos" => "tos#update", as: "tos"

  scope "/pages" do
    resources :jobs, :only => [:show, :index]
    get ":name" => "home#pages", constraints: { name: /[-a-zA-Z_]+/ }, :as => "pages"
  end
  get "/tour" => "home#tour", as: "tour"

  namespace :admin do
    resources :users, :only => [:show, :new, :create, :edit, :update, :index]
    resources :jobs
  end

  resource :feedback, only: [:new, :create], controller: "feedback"

  scope "/:username" do
    get "/" => "users#show", :as => "user_profile"

    resources :channels do
      collection do
        post "toggle/fact" => "channels#toggle_fact",  :as => "toggle_fact"
      end

      member do
        resources :subchannels, only: [:index] do
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

          scope "/:fact_id" do
            delete "/" => "channels#remove_fact",  :as => "remove_fact_from"

            match "/evidence_search" => "facts#evidence_search"

            resources :supporting_evidence, :weakening_evidence do
              post    "opinion/:type" => "evidence#set_opinion", :as => "set_opinion"
              delete  "opinion/" => "evidence#remove_opinions", :as => "delete_opinion"
            end
          end
        end
      end
    end
  end


  ##################
  # SOON TO DEPRECATE ROUTES (move to restful resources):
  ##################

  # Prepare a new Fact
  match "/factlink/intermediate" => "facts#intermediate"
end
