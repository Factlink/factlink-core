server 'testserver.fct.li', :app, :web, :primary => true

set :deploy_env, 'testserver'

role :web, "testserver.fct.li"                          # Your HTTP server, Apache/etc
role :app, "testserver.fct.li"                          # This may be the same as your `Web` server
role :db,  "testserver.fct.li", :primary => true # This is where Rails migrations will run