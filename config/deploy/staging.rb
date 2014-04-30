server 'factlink-staging.inverselink.com', :app, :web, :primary => true

set :full_url, 'https://factlink-staging.inverselink.com'

set :deploy_env, 'staging'
set :rails_env,  'staging' # Also used by capistrano for some specific tasks

role :web, "factlink-staging.inverselink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink-staging.inverselink.com"                          # This may be the same as your `Web` server
role :db,  "factlink-staging.inverselink.com", :primary => true # This is where Rails migrations will run
