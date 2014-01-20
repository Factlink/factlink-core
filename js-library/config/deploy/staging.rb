server 'factlink-static-staging.inverselink.com', :app, :web, :primary => true

set :deploy_env, 'staging'

role :web, "factlink-static-staging.inverselink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink-static-staging.inverselink.com"                          # This may be the same as your `Web` server
role :db,  "factlink-static-staging.inverselink.com", :primary => true # This is where Rails migrations will run
