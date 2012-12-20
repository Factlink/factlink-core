FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # User Authentication
  devise_for :users, :controllers => {  confirmations: "users/confirmations",
                                        invitations:   "users/invitations",
                                        registrations: "users/registrations",
                                        sessions:      "users/sessions",
                                        passwords:      "users/passwords"
                                      }

  # Web Front-end
  root :to => "home#index"


  # Javascript Client calls
  # TODO: replace /site/ gets with scoped '/sites/', and make it a resource (even if it only has show)
  get   "/site/blacklisted" => "sites#blacklisted"
  get   "/site/count" => "sites#facts_count_for_url"
  get   "/site" => "sites#facts_for_url"
  get   "/site/:id/top_topics" => "sites#top_topics"

  # Prepare a new Fact
  # If you change this route, don't forget to change it in application.rb
  # as well (frame busting)
  match "/factlink/intermediate" => "facts#intermediate"

  # Static js micro templates
  get "/templates/:name" => "js_lib#show_template",
      constraints: { name: /[-a-zA-Z_]+/ }

  get "/jslib/:path" => "js_lib#redir",
      constraints: { path: /[-a-zA-Z0-9_.\/]*/ }

  # Generate the images for the indicator used in the js-lib
  get "/system/wheel/:percentages" => "wheel#show"

  # Show Facts#new as unauthenticated user to show the correct login link
  resources :facts, only: [:new, :update, :create] do
    member do
      post    "/opinion/:type"    => "facts#set_opinion",     :as => "set_opinion"
      delete  "/opinion"          => "facts#remove_opinions", :as => "delete_opinion"
      scope '/comments' do
        post "/:type" => 'comments#create'
        delete "/:type/:id" => 'comments#destroy'
        put "/:type/:id" => 'comments#update'

        scope '/:type/:id' do
          get 'sub_comments' => 'comments#sub_comments_index'
          post 'sub_comments' => 'comments#sub_comments_create'
          delete 'sub_comments/:id' => 'comments#sub_comments_destroy'
        end
      end
    end
  end

  resources :feedback

  get "/:fact_slug/f/:id" => "facts#extended_show", as: "frurl_fact"

  authenticated :user do

    resources :facts, :except => [:edit, :index, :update] do
      resources :evidence

      resources :supporting_evidence do
        collection do
          get     "combined"      => "supporting_evidence#combined_index"
        end
      end

      resources :weakening_evidence do
        collection do
          get     "combined"      => "weakening_evidence#combined_index"
        end
      end

      resources :supporting_evidence, :weakening_evidence, :except => [:index] do
        member do
          get     "opinion"       => "evidence#opinion"
          post    "opinion/:type" => "evidence#set_opinion",      :as => "set_opinion"
          delete  "opinion/"      => "evidence#remove_opinions",  :as => "delete_opinion"

          get     'sub_comments'     => 'evidence#sub_comments_index'
          post    'sub_comments'     => 'evidence#sub_comments_create'
          delete  'sub_comments/:id' => 'evidence#sub_comments_destroy'
        end
      end

      member do
        post    "/opinion/:type"    => "facts#set_opinion",     :as => "set_opinion"
        delete  "/opinion"          => "facts#remove_opinions", :as => "delete_opinion"
        match   "/evidence_search"  => "facts#evidence_search"
        get     "/channels"         => "facts#get_channel_listing"
        get     "/believers"        => "facts#believers"
        get     "/disbelievers"     => "facts#disbelievers"
        get     "/doubters"         => "facts#doubters"
      end
    end

    # Search and infinite scrolling
    match "/search(/page/:page)(/:sort/:direction)" => "search#search", :as => "factlink_overview"

    namespace :admin, path: 'a' do
      resources :users, :only => [:show, :new, :create, :edit, :update, :index] do
        collection do
          get :reserved
        end

        member do
          put :approve
        end
      end
    end

    # Seems to me we want to lose the scope "/:username" later and place all
    # stuff in this resource?
    devise_scope :user do
      resources :users, path: "", only: [ :edit, :update ] do
        get "/password/edit" => "users/registrations#edit_password"
        put "/password" => "users/registrations#update_password", as: "update_password"
      end
    end
  end

  get "/auth/:service/callback" => "identities#service_callback", as: "social_auth"
  delete "/auth/:service/deauthorize" => "identities#service_deauthorize"

  resources :conversations, only: [:index, :show, :create], path: 'c' do
    resources :messages, only: [:create, :show]
  end

  scope "/:username" do
    get "/" => "users#show", :as => "user_profile"
    put "/" => "users#update"

    get 'notification-settings' => "channels#backbone_page", as: "user_notification_settings"

    scope "/activities" do
      get "/" => "users#activities", :as => "activities"
      post "/mark_as_read" => "users#mark_activities_as_read", :as => "mark_activities_as_read"
    end


    resources :channels do
      collection do
        get "find" => "channels#search", :as => "find"
      end

      get "/facts/:fact_id" => "facts#extended_show", as: "fact"

      resources :subchannels, only: [:index, :destroy, :create, :update] do
        collection do
          post "add/:id/",     :as => "add",     :action => "create"
          post "remove/:id/",  :as => "remove",  :action => "destroy"
        end
      end

      resources :activities, only: [:index, :create, :update, :destroy],
                controller: 'channel_activities' do |variable|
        collection do
          get "last_fact"
          get "facts/:fact_id" => "facts#extended_show", as: "fact"
        end
      end

      member do

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

  resources :topics, path: 't', only: [] do
    collection do
      get :top
      get :top_channels
    end
    member do
      get :related_user_channels
    end
  end

  get  "/p/tos"     => "tos#show",        as: "tos"
  post "/p/tos"     => "tos#update",      as: "tos"

  scope "/p/tour" do
    get "youre-almost-done" => "tour#almost_done", as: "almost_done"
    get "create-your-first-factlink" => "tour#create_your_first_factlink", as: "create_your_first_factlink"
    get "choose-channels" => "tour#choose_channels", as: "choose_channels"
  end

  get  "/p/privacy" => "privacy#privacy", as: "privacy"

  scope "/p" do
    get ":name" => "home#pages", :as => "pages",  :constraints => {:name => /([-a-zA-Z_\/]+)/}
  end


  # Scope for user specific actions
  # I made this scope so we don't always have to know the current users username in de frontend
  # I'm abusing it for the search now as well, as this place looks like the best
  # since we cannot nest it in another user
  scope "/u" do
    put "/seen_messages" => "users#seen_message", as: 'see_message'
    get "/search" => "users#search", as: 'search_users'
    get "/channel_suggestions" => "users#channel_suggestions", as: 'channel_suggestions'
  end

end
