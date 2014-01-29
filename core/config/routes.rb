FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # User Authentication
  devise_for :users, :controllers => {  confirmations: "users/confirmations",
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

  # Prepare a new Fact
  # If you change this route, don't forget to change it in application.rb
  # as well (frame busting)
  get '/client/*page' => 'client#show'

  resources :facts, only: [:create, :show, :destroy] do
    resources :opinionators, only: [:index, :create, :destroy, :update]

    member do
      get     "/evidence_search"  => "facts#evidence_search"
      post    "/share"            => "facts#share"

      scope '/comments' do
        post "/" => 'comments#create'
        get "/" => 'comments#index'
        delete "/:id" => 'comments#destroy'
        put "/:id/opinion" => 'comments#update_opinion'

        scope '/:comment_id' do
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
  end

  resources :feedback # TODO: RESTRICT

  get "/:fact_slug/f/:id" => "facts#discussion_page_redirect"
  get "/f/:id" => "facts#discussion_page"

  # Search
  get "/search" => "search#search", as: "search"

  authenticated :user do
    namespace :admin, path: 'a' do
      get 'info'
      get 'cause_error'
      resource :global_feature_toggles,
            controller: :global_feature_toggles,
            only: [:show, :update ]

      resources :users, only: [:show, :edit, :update, :index, :destroy]
    end
  end

  # Seems to me we want to lose the scope "/:username" later and place all
  # stuff in this resource?
  devise_scope :user do
    resources :users, path: "", only: [:edit, :update] do
      get "/password/edit" => "users/edit_password#edit_password"
      put "/password" => "users/edit_password#update_password", as: "update_password"
    end
  end

  authenticated :user do
    get "/auth/:provider_name/callback" => "accounts/social_connections#callback", as: "social_auth"
    delete "/auth/:provider_name/deauthorize" => "accounts/social_connections#deauthorize"
  end

  get "/auth/:provider_name/callback" => "accounts/social_registrations#callback"
  post "/auth/new" => "accounts/social_registrations#create", as: 'social_accounts_new'
  get "/users/sign_in_or_up" => "accounts/factlink_accounts#new", as: 'factlink_accounts_new'
  post "/users/sign_in_or_up/in" => "accounts/factlink_accounts#create_session", as: 'factlink_accounts_create_session'
  post "/users/sign_in_or_up/up" => "accounts/factlink_accounts#create_account", as: 'factlink_accounts_create_account'

  scope "/:username" do
    get "/" => "users#show", as: "user_profile"
    put "/" => "users#update"
    delete "/" => "users#destroy"

    resources :created_facts, only: [:index]

    get '/feed' => "feed#index", as: 'feed'
    get '/feed/count' => "feed#count", as: 'feed_count'

    get 'notification-settings' => "users#notification_settings", as: "user_notification_settings"

    scope "/activities" do
      get "/" => "users#activities", as: "activities"
      post "/mark_as_read" => "users#mark_activities_as_read", as: "mark_activities_as_read"
    end

    resources :following, only: [:destroy, :update, :index], controller: 'user_following'
  end

  scope "/p/tour" do
    get 'setup-account' => 'users/setup#edit', as: 'setup_account'
    put 'setup-account' => 'users/setup#update'
    get "install-extension" => "tour#install_extension", as: "install_extension"
    get "interests" => "tour#interests", as: "interests"
    get "tour-done" => "tour#tour_done", as: "tour_done"
  end

  scope "/p" do
    get ":name" => "home#pages", as: "pages",  constraints: {name: /([-a-zA-Z_\/]+)/}
  end


  # Scope for user specific actions
  # I made this scope so we don't always have to know the current users username in de frontend
  scope "/u" do
    put "/seen_messages" => "users#seen_messages", as: 'see_messages'
    get "/tour_users" => "users#tour_users", as: 'tour_users'
    get "/unsubscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'unsubscribe', as: :unsubscribe
    get "/subscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'subscribe', as: :subscribe
  end

end
