server 'staging.fct.li', :app, :web, :primary => true

set :deploy_env, 'staging'

role :web, "staging.fct.li"                          # Your HTTP server, Apache/etc
role :app, "staging.fct.li"                          # This may be the same as your `Web` server
role :db,  "staging.fct.li", :primary => true # This is where Rails migrations will run