server 'demo.factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'

set :branch, "master"

role :web, "demo.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "demo.factlink.com"                          # This may be the same as your `Web` server
role :db,  "demo.factlink.com", :primary => true # This is where Rails migrations will run