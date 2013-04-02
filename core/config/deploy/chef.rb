server '10.253.0.101', :app, :web, :primary => true

set :full_url, 'https://10.253.0.101'

set :deploy_env, 'chef'
set :rails_env,  'chef' # Also used by capistrano for some specific tasks

role :web, '10.253.0.101'                          # Your HTTP server, Apache/etc
role :app, '10.253.0.101'                          # This may be the same as your `Web` server
role :db,  '10.253.0.101', :primary => true # This is where Rails migrations will run
