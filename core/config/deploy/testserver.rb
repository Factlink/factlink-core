server 'factlink-testserver.inverselink.com', :app, :web, :primary => true

set :full_url, 'https://factlink-testserver.inverselink.com'

set :deploy_env, 'testserver'
set :rails_env,  'testserver' # Also used by capistrano for some specific tasks

set :branch, 'feature/chef'

role :web, "factlink-testserver.inverselink.com"                   # Your HTTP server, Apache/etc
role :app, "factlink-testserver.inverselink.com"                   # This may be the same as your `Web` server
role :db,  "factlink-testserver.inverselink.com", :primary => true # This is where Rails migrations will run
