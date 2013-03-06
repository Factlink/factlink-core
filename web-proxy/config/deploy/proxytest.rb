server '89.188.27.175', :app, :web, :primary => true

set :deploy_env, 'proxytest'

role :web, "89.188.27.175"                          # Your HTTP server, Apache/etc
role :app, "89.188.27.175"                          # This may be the same as your `Web` server
role :db,  "89.188.27.175", :primary => true # This is where Rails migrations will run
