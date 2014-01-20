server 'static.factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'

role :web, "static.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "static.factlink.com"                          # This may be the same as your `Web` server
role :db,  "static.factlink.com", :primary => true # This is where Rails migrations will run
