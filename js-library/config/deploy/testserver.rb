server 'factlink-static-testserver.inverselink.com', :app, :web, :primary => true

set :deploy_env, 'testserver'

role :web, "factlink-static-testserver.inverselink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink-static-testserver.inverselink.com"                          # This may be the same as your `Web` server
role :db,  "factlink-static-testserver.inverselink.com", :primary => true # This is where Rails migrations will run
