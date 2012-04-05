server 'fct.li', :app, :web, :primary => true

set :deploy_env, 'production'

role :web, "fct.li"                          # Your HTTP server, Apache/etc
role :app, "fct.li"                          # This may be the same as your `Web` server
role :db,  "fct.li", :primary => true # This is where Rails migrations will run