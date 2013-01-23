server 'factlink.com', :app, :web, :primary => true

set :full_url, 'https://factlink.com'

set :deploy_env, 'production'
set :rails_env,  'production' # Also used by capistrano for some specific tasks

role :web, "factlink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink.com"                          # This may be the same as your `Web` server

role :db,  "factlink.com", :primary => true # This is where Rails migrations will run

after "deploy:update", "newrelic:notice_deployment"
