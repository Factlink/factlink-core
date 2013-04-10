server '10.253.0.102', :app, :web, :primary => true

set :deploy_env, 'vagrant'

set :branch, 'feature/chef'
