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
  get   "/site/top_topics" => "sites#top_topics"

  # Prepare a new Fact
  # If you change this route, don't forget to change it in application.rb
  # as well (frame busting)
  get "/factlink/intermediate" => "facts#intermediate"

  # Static js micro templates
  get "/templates/create" => "js_lib#create"
  get "/templates/indicator" => "js_lib#indicator"

  # Show Facts#new as unauthenticated user to show the correct login link
  resources :facts, only: [:new, :create, :show, :destroy] do
    resources :interactors, only: [:index, :show], controller: 'fact_interactors'

    member do
      post    "/opinion/:type"    => "facts#set_opinion",     as: "set_opinion"
      delete  "/opinion"          => "facts#remove_opinions", as: "delete_opinion"
      get     "/evidence_search"  => "facts#evidence_search"

      scope '/comments' do
        post "/:type" => 'comments#create'
        delete "/:type/:id" => 'comments#destroy'
        put "/:type/:id" => 'comments#update'

        scope '/:type/:comment_id' do
          scope '/sub_comments' do
            get '' => 'sub_comments#index'
            post '' => 'sub_comments#create'
            delete "/:sub_comment_id" => 'sub_comments#destroy'
          end
        end
      end
    end
    collection do
      get 'recently_viewed' => "facts#recently_viewed"
    end

    resources :supporting_evidence, only: [] do
      collection do
        get     "combined"      => "supporting_evidence#combined_index"
      end
    end

    resources :weakening_evidence, only: [] do
      collection do
        get     "combined"      => "weakening_evidence#combined_index"
      end
    end
    resources :supporting_evidence, :weakening_evidence, only: [:show, :create, :destroy] do
      member do
        post    "opinion/:type" => "evidence#set_opinion",      as: "set_opinion"
        delete  "opinion/"      => "evidence#remove_opinions",  as: "delete_opinion"
        scope '/sub_comments' do
          get '' => 'sub_comments#index'
          post '' => 'sub_comments#create'
          delete "/:sub_comment_id" => 'sub_comments#destroy'
        end
      end
    end
  end

  resources :feedback # TODO RESTRICT

  get "/:fact_slug/f/:id" => "facts#discussion_page"

  # Search
  get "/search" => "search#search", as: "search"

  authenticated :user do
    namespace :admin, path: 'a' do
      get 'info'
      resource :global_feature_toggles,
            controller: :global_feature_toggles,
            only: [:show, :update ]

      resources :users, only: [:show, :edit, :update, :index] do
        collection do
          get :reserved
        end

        member do
          put :approve
        end
      end
    end
  end

  # Seems to me we want to lose the scope "/:username" later and place all
  # stuff in this resource?
  devise_scope :user do
    resources :users, path: "", only: [:edit, :update] do
      get "/password/edit" => "users/registrations#edit_password"
      put "/password" => "users/registrations#update_password", as: "update_password"
    end
  end

  get "/auth/:service/callback" => "identities#service_callback", as: "social_auth"
  delete "/auth/:service/deauthorize" => "identities#service_deauthorize"

  resources :conversations, only: [:index, :show, :create], path: 'm' do
    resources :messages, only: [:create, :show]
  end

  # old conversation urls, remove before 2014
  get "/c" => redirect("/m")
  get "/c/:id" => redirect("/m/%{id}")
  get "/c/:id/messages/:message_id" => redirect("/m/%{id}/messages/%{message_id}")

  scope "/:username" do
    get "/" => "users#show", as: "user_profile"
    put "/" => "users#update"

    get 'notification-settings' => "users#notification_settings", as: "user_notification_settings"

    scope "/activities" do
      get "/" => "users#activities", as: "activities"
      post "/mark_as_read" => "users#mark_activities_as_read", as: "mark_activities_as_read"
    end

    resources :channels, except: [:new, :edit] do
      collection do
        get "find" => "channels#search", as: "find"
      end

      get "/facts/:fact_id" => "facts#discussion_page_redirect" # remove before 2014

      resources :subchannels, only: [:index, :destroy, :create, :update] do
        collection do
          post "add/:id/",     as: "add",     action: "create"
          post "remove/:id/",  as: "remove",  action: "destroy"
        end
      end

      resources :activities, only: [:index, :create, :update, :destroy],
                controller: 'channel_activities' do |variable|
        collection do
          get "count"
          get "facts/:fact_id" => "facts#discussion_page_redirect" # remove before 2014
        end
      end

      member do

        post "toggle/fact/:fact_id/" => "channels#toggle_fact"

        post "add/:fact_id"     => "channels#add_fact"
        post "remove/:fact_id"  => "channels#remove_fact"

        post "follow"   => "channels#follow"
        post "unfollow" => "channels#unfollow"

        scope "/facts" do
          get "/" => "channels#facts", as: "get_facts_for"
          post "/" => "channels#create_fact", as: "create_fact_for"

          scope "/:fact_id" do
            delete "/" => "channels#remove_fact",  as: "remove_fact_from"

            get "/evidence_search" => "facts#evidence_search"

            resource :supporting_evidence, :weakening_evidence do
              scope '/:evidence_id' do
                post    "/opinion/:type", action: :set_opinion,  as: "set_opinion"
                delete  "/opinion/", action:  :remove_opinions,  as: "delete_opinion"
              end
            end
          end
        end
      end
    end

    resources :followers, only: [:destroy, :update, :index], controller: 'user_followers'
    resources :following, only: [:destroy, :update, :index], controller: 'user_following'
    resources :favourite_topics, only: [:destroy, :update, :index], controller: 'user_favourite_topics'
  end

  resources :topics, path: 't', only: [:show] do
    collection do
      get :top
    end

    member do
      scope "/facts" do
        get "/" => "topics#facts", as: "topic_facts"
        get "/:fact_id" => "facts#discussion_page_redirect" # remove before 2014
      end
    end
  end

  get  "/p/tos"     => "tos#show",        as: "tos"
  post "/p/tos"     => "tos#update",      as: "tos"

  scope "/p/tour" do
    get "install-extension" => "tour#install_extension", as: "install_extension"
    get "create-your-first-factlink" => "tour#create_your_first_factlink", as: "create_your_first_factlink"
    get "interests" => "tour#interests", as: "interests"
    get "tour-done" => "tour#tour_done", as: "tour_done"
  end

  get  "/p/privacy" => "privacy#privacy", as: "privacy"

  scope "/p" do
    get ":name" => "home#pages", as: "pages",  constraints: {name: /([-a-zA-Z_\/]+)/}
  end


  # Scope for user specific actions
  # I made this scope so we don't always have to know the current users username in de frontend
  # I'm abusing it for the search now as well, as this place looks like the best
  # since we cannot nest it in another user
  scope "/u" do
    put "/seen_messages" => "users#seen_messages", as: 'see_messages'
    get "/search" => "users#search", as: 'search_users'
    get "/tour_users" => "users#tour_users", as: 'tour_users'
    get "/unsubscribe/:token/:type" => 'mail_subscriptions#update', as: :unsubscribe
  end

end
