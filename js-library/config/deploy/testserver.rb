server 'factlink-testserver.inverselink.com', :app, :web, :primary => true

set :deploy_env, 'testserver'

role :web, "factlink-testserver.inverselink.com"                          # Your HTTP server, Apache/etc
role :app, "factlink-testserver.inverselink.com"                          # This may be the same as your `Web` server
role :db,  "factlink-testserver.inverselink.com", :primary => true # This is where Rails migrations will run
