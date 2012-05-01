FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # User Authentication
  devise_for :users, :controllers => {  confirmations: "users/confirmations",
                                        invitations:   "users/invitations",
                                        registrations: "users/registrations",
                                        sessions:      "users/sessions"
                                      }

  # Web Front-end
  root :to => "home#index"

  # Javascript Client calls
  # TODO: replace /site/ gets with scoped '/sites/', and make it a resource (even if it only has show)
  get   "/site/blacklisted" => "sites#blacklisted"
  get   "/site/count" => "sites#facts_count_for_url"
  get   "/site" => "sites#facts_for_url"

  # Prepare a new Fact
  # If you change this route, don't forget to change it in application.rb
  # as well (frame busting)
  match "/factlink/intermediate" => "facts#intermediate"

  # Static js micro templates
  get "/templates/:name" => "templates#show", constraints: { name: /[-a-zA-Z_]+/ }

  # Generate the images for the indicator used in the js-lib
  get "/system/wheel/:percentages" => "wheel#show"

  # Show Facts#new as unauthenticated user to show the correct login link
  resources :facts, only: [:new, :update] do
    member do
      get 'popup_show' => "facts#popup_show"
      post    "/opinion/:type"    => "facts#set_opinion",     :as => "set_opinion"
      delete  "/opinion"          => "facts#remove_opinions", :as => "delete_opinion"
    end
  end

  get "/:fact_slug/f/:id" => "facts#extended_show", as: "frurl_fact"


  authenticated :user do
    get "/p/tour" => "home#tour", as: "tour"

    resources :facts, :except => [:edit, :index, :update] do
      resources :evidence

      resources :supporting_evidence, :weakening_evidence do
        member do
          get     "opinion"       => "evidence#opinion"
          post    "opinion/:type" => "evidence#set_opinion",      :as => "set_opinion"
          delete  "opinion/"      => "evidence#remove_opinions",  :as => "delete_opinion"
        end
      end

      member do
        post    "/opinion/:type"    => "facts#set_opinion",     :as => "set_opinion"
        delete  "/opinion"          => "facts#remove_opinions", :as => "delete_opinion"
        match   "/evidence_search"  => "facts#evidence_search"
        get     "/channels"         => "facts#get_channel_listing"
      end
    end

    # Search and infinite scrolling
    match "/search(/page/:page)(/:sort/:direction)" => "home#search", :as => "factlink_overview"

    namespace :admin, path: 'a' do
      resources :users, :only => [:show, :new, :create, :edit, :update, :index] do
        collection do
          get :reserved
        end

        member do
          put :approve
        end
      end

      resources :jobs
    end

    # Seems to me we want to lose the scope "/:username" later and place all
    # stuff in this resource?
    devise_scope :user do
      resources :users, path: "", only: [ :edit, :update ] do
        get "/password/edit" => "users/registrations#edit_password"
        put "/password" => "users/registrations#update_password", as: "update_password"
      end
    end

    scope "/:username" do
      get "/" => "users#show", :as => "user_profile"

      scope "/activities" do
        get "/" => "users#activities", :as => "activities"
        post "/mark_as_read" => "users#mark_activities_as_read", :as => "mark_activities_as_read"
      end

      resources :channels do
        collection do
          post "toggle/fact" => "channels#toggle_fact",  :as => "toggle_fact"
        end
        resources :subchannels, only: [:index, :destroy] do
          collection do
            post "add/:id/",     :as => "add",     :action => "add"
            post "remove/:id/",  :as => "remove",  :action => "destroy"
          end
        end

        member do

          get "activities",     :as => "activities"

          post "toggle/fact/:fact_id/" => "channels#toggle_fact"

          post "add/:fact_id"     => "channels#add_fact"
          post "remove/:fact_id"  => "channels#remove_fact"

          scope "/facts" do
            get "/" => "channels#facts", :as => "get_facts_for"
            post "/" => "channels#create_fact", :as => "create_fact_for"

            scope "/:fact_id" do
              delete "/" => "channels#remove_fact",  :as => "remove_fact_from"

              match "/evidence_search" => "facts#evidence_search"


              resource :supporting_evidence, :weakening_evidence do
                scope '/:evidence_id' do
                  post    "/opinion/:type", action: :set_opinion,  :as => "set_opinion"
                  delete  "/opinion/", action:  :remove_opinions,  :as => "delete_opinion"
                end
              end
            end
          end
        end
      end
    end

  end

  resources :topics, path: 't', only: [] do
    member do
      get :related_users
    end
  end

  get  "/p/tos"     => "tos#show",        as: "tos"
  post "/p/tos"     => "tos#update",      as: "tos"
  get  "/p/privacy" => "privacy#privacy", as: "privacy"

  scope "/p" do
    resources :jobs, :only => [:show, :index]
    get ":name" => "home#pages", :as => "pages"
  end

  get "/x/:id" => "fake_facts#show"
end
