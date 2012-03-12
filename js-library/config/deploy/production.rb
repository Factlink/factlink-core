server 'beta.factlink.com', :app, :web, :primary => true

set :deploy_env, 'production'

role :web, "beta.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "beta.factlink.com"                          # This may be the same as your `Web` server
role :db,  "beta.factlink.com", :primary => true # This is where Rails migrations will run