server 'factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'

role :web, "factlink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink.com"                          # This may be the same as your `Web` server
role :db,  "factlink.com", :primary => true # This is where Rails migrations will run
