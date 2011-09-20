#############
# Application
set :application, "factlink-core"

########
# Stages
set :stages, %w(testserver production)
set :default_stage, "testserver"
require 'capistrano/ext/multistage'

#################
# Bundler support
require "bundler/capistrano"

#############
# RVM support
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.2'
# set :rvm_type, :user  # Don't use system-wide RVM



set :user, "root"
set :use_sudo,    false

# Repository
set :scm, :git
set :repository,  "git@codebasehq.com:factlink/factlink/factlink-core.git"
set :branch, "develop"  # Can be moved to deploy/production.rb and deploy.testserver.rb

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last
after "deploy", "deploy:migrate"



ssh_options[:forward_agent] = true


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :all do
    # Update the static files
    run 'cd /applications/factlink-js-library/ ; git checkout develop ; git pull'

    # Update the Proxy
    run "cd /applications/web-proxy ; git checkout develop ; git pull ; killall forever ; killall node ; NODE_ENV=testserver CONFIG_PATH=#{deploy_to}/current/config/ forever start server.js "
    
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:all', 'deploy'
after 'deploy', 'deploy:restart'