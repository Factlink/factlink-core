FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # User Authentication
  devise_for :users, :controllers => {  confirmations: "users/confirmations",
                                        sessions:      "users/sessions",
                                        passwords:      "users/passwords"
                                      }
  mount Ohnoes::Engine => '/ohnoes'

  # Web Front-end
  root :to => "home#index"

  scope '/api/beta' do
    get '/feed' => "api/feed#global", as: 'something_alse_than_feed_as_well'
    get '/feed/personal' => "api/feed#personal", as: 'something_else_than_feed'
    get '/feed/discussions' => "api/feed#discussions", as: "insert_nonsense_here"
    get '/annotations/search' => 'api/annotations#search' #TODO:evil URL, clashes with get-by-id.
    post '/annotations' => 'api/annotations#create'
    get '/annotations/:id' => 'api/annotations#show'
    post '/groups' => 'api/groups#create'
    get '/groups' => 'api/groups#index'
    put '/users/:username/groups/:group_id' => 'api/groups#add_member'
    get '/users/:username/feed' => 'api/users#feed'
    get '/users/:username' => 'api/users#show'
    put '/users/:original_username' => 'api/users#update'
    put '/users/:username/password' => 'api/users#change_password'
    get '/session' => 'api/sessions#current'
    post '/users/:username/delete' => 'api/users#destroy'
    get '/search' => "api/search#all", as: 'something_else_than_search'
  end

  # Javascript Client calls
  # TODO: replace /site/ gets with scoped '/sites/', and make it a resource (even if it only has show)
  get   "/site" => "sites#facts_for_url"

  # Prepare a new Fact
  # If you change this route, don't forget to change it in application.rb
  # as well (frame busting)
  get '/client/*page' => 'client#show'

  resources :facts, only: [] do
    resources :opinionators, only: [:index, :create, :destroy, :update]

    member do
      scope '/comments' do
        post "/" => 'comments#create'
        put "/:comment_id" => 'comments#update'
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
  end

  get "/d/:id" => "frontend#show" #KL: edit discussion/annotation/factlink on site

  get "/:fact_slug/f/:id" => "facts#discussion_page_redirect"
  get "/f/:id" => "facts#discussion_page_redirect"

  get "/in-your-browser" => "home#in_your_browser", as: 'in_your_browser'
  get "/on-your-site" => "home#on_your_site", as: 'on_your_site'
  get "/terms-of-service" => "home#terms_of_service", as: 'terms_of_service'
  get "/privacy" => "home#privacy", as: 'privacy'
  get "/about" => "home#about", as: 'about'
  get "/jobs" => "home#jobs", as: 'jobs'

  # Support old urls until Google search index is updated
  get '/p/about', to: redirect("/about")
  get '/p/team', to: redirect("/about")
  get '/p/contact', to: redirect("/about")
  get '/p/jobs', to: redirect("/jobs")
  get '/p/privacy', to: redirect("/privacy")
  get '/publisher', to: redirect("/on-your-site")
  get '/p/terms-of-service', to: redirect("/terms-of-service")
  get '/p/tos', to: redirect("/terms-of-service")
  get '/p/on-your-site', to: redirect("/on-your-site")

  get "/blog" => "blog#index", as: 'blog_index'
  get "/blog/4-lessons-you-can-learn-from-factlinks-pivot" => "blog#4_lessons_you_can_learn_from_factlinks_pivot", as: 'blog_4_lessons_you_can_learn_from_factlinks_pivot'
  get "/blog/the-annotated-web" => "blog#the_annotated_web", as: 'blog_the_annotated_web'
  get "/blog/learning-from-discussions" => "blog#learning_from_discussions", as: 'blog_learning_from_discussions'
  get "/blog/discussion-of-the-week-10" => "blog#discussion_of_the_week_10", as: 'blog_discussion_of_the_week_10'
  get "/blog/discussion-of-the-week-9" => "blog#discussion_of_the_week_9", as: 'blog_discussion_of_the_week_9'
  get "/blog/discussion-of-the-week-8" => "blog#discussion_of_the_week_8", as: 'blog_discussion_of_the_week_8'
  get "/blog/discussion-of-the-week-7" => "blog#discussion_of_the_week_7", as: 'blog_discussion_of_the_week_7'
  get "/blog/discussion-of-the-week-6" => "blog#discussion_of_the_week_6", as: 'blog_discussion_of_the_week_6'
  get "/blog/discussion-of-the-week-5" => "blog#discussion_of_the_week_5", as: 'blog_discussion_of_the_week_5'
  get "/blog/discussion-of-the-week-4" => "blog#discussion_of_the_week_4", as: 'blog_discussion_of_the_week_4'
  get "/blog/discussion-of-the-week-3" => "blog#discussion_of_the_week_3", as: 'blog_discussion_of_the_week_3'
  get "/blog/discussion-of-the-week-2" => "blog#discussion_of_the_week_2", as: 'blog_discussion_of_the_week_2'
  get "/blog/discussion-of-the-week-1" => "blog#discussion_of_the_week_1", as: 'blog_discussion_of_the_week_1'
  get "/blog/stubbing-the-object-under-test-and-getting-away-without-it" => "blog#stubbing_the_object_under_test_and_getting_away_without_it", as: 'blog_stubbing_the_object_under_test_and_getting_away_without_it'
  get "/blog/one-legged-standup" => "blog#one_legged_standup", as: 'blog_one_legged_standup'
  get "/blog/yolo-spend-less-time-deploying-more-time-for-development" => "blog#yolo_spend_less_time_deploying_more_time_for_development", as: 'blog_yolo_spend_less_time_deploying_more_time_for_development'
  get "/blog/increasing-development-speed-by-decreasing-cycle-time" => "blog#increasing_development_speed_by_decreasing_cycle_time", as: 'blog_increasing_development_speed_by_decreasing_cycle_time'
  get "/blog/how-apis-should-be-drop-in-keys-running-in-1-minute" => "blog#how_apis_should_be_drop_in_keys_running_in_1_minute", as: 'blog_how_apis_should_be_drop_in_keys_running_in_1_minute'
  get "/blog/dont-look-for-a-ux-guy-be-a-ux-guy" => "blog#dont_look_for_a_ux_guy_be_a_ux_guy", as: 'blog_dont_look_for_a_ux_guy_be_a_ux_guy'
  get "/blog/building-a-collective-perspective" => "blog#building_a_collective_perspective", as: 'blog_building_a_collective_perspective'
  get "/blog/knights-news-challenge" => "blog#knights_news_challenge", as: 'blog_knights_news_challenge'
  get "/blog/development_process" => "blog#development_process", as: 'blog_development_process'
  get "/blog/collective-knowledge" => "blog#collective_knowledge", as: 'blog_collective_knowledge'

  authenticated :user do
    namespace :admin, path: 'a' do
      get 'info'
      get 'clean'
      get 'cause_error'
      resource :global_feature_toggles,
            controller: :global_feature_toggles,
            only: [:show, :update ]

      resources :users, only: [:show, :edit, :update, :index, :destroy]
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
  get "/users/out" => "accounts/sign_out#destroy"

  get "/users/deleted" => "users#deleted"

  get '/feed' => "frontend#show", as: 'feed'
  get '/:unused/feed', to: redirect("/feed")

  get "/search" => "frontend#show", as: "search"

  scope "/user/:username" do
    get "/" => "frontend#user_profile", as: "user_profile"
    get "/edit" => "frontend#show", as: 'edit_user'
    get "/groups" => "frontend#show"
    get "/change-password" => "frontend#show", as: 'change_password'
    get "/notification-settings" => "frontend#show", as: 'user_notification_settings'

    resources :following, only: [:destroy, :update, :index], controller: 'user_following'
  end

  # Scope for user specific actions
  # I made this scope so we don't always have to know the current users username in de frontend
  scope "/u" do
    get "/unsubscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'unsubscribe', as: :unsubscribe
    get "/subscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'subscribe', as: :subscribe
  end
end
