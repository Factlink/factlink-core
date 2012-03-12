server 'testserver.factlink.com', :app, :web, :primary => true

set :full_url, 'https://testserver.factlink.com'

set :deploy_env, 'testserver'
set :rails_env,  'testserver' # Also used by capistrano for some specific tasks

role :web, "testserver.factlink.com"                          # Your HTTP server, Apache/etc
role :app, "testserver.factlink.com"                          # This may be the same as your `Web` server
role :db,  "testserver.factlink.com", :primary => true # This is where Rails migrations will run