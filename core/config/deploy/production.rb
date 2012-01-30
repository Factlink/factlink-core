server 'beta.factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'
set :rails_env,  'production' # Also used by capistrano for some specific tasks

set :branch, "master"

role :web, "beta.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "beta.factlink.com"                          # This may be the same as your `Web` server
role :db,  "beta.factlink.com", :primary => true # This is where Rails migrations will run
