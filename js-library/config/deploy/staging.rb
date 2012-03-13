server 'staging.factlink.com', :app, :web, :primary => true

set :deploy_env, 'staging'

role :web, "staging.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "staging.factlink.com"                          # This may be the same as your `Web` server
role :db,  "staging.factlink.com", :primary => true # This is where Rails migrations will run