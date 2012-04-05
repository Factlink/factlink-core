server 'beta.fct.li', :app, :web, :primary => true

set :deploy_env, 'production'

role :web, "beta.fct.li"                          # Your HTTP server, Apache/etc
role :app, "beta.fct.li"                          # This may be the same as your `Web` server
role :db,  "beta.fct.li", :primary => true # This is where Rails migrations will run