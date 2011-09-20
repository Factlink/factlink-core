server 'testserver.factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'

set :branch, "develop"

role :web, "testserver.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "testserver.factlink.com"                          # This may be the same as your `Web` server
role :db,  "testserver.factlink.com", :primary => true # This is where Rails migrations will run