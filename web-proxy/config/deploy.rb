#############
# Application
set :application, "web-proxy"

########
# Stages
set :stages, %w(testserver production)
set :default_stage, "testserver"
require 'capistrano/ext/multistage'

#############
# RVM support
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# Load RVM's capistrano plugin.    
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2'

set :user, "root"
set :use_sudo,    false

# Repository
set :scm, :git
set :repository,  "git@codebasehq.com:factlink/factlink/web-proxy.git"

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

ssh_options[:forward_agent] = true


def set_conf_path
  "export CONFIG_PATH=/applications/factlink-core/current/config/; export NODE_ENV=#{deploy_env};"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :build do
  end
  
  task :start do
    
    deploy.stop
    
    puts "\n\nstarting node proxy using forever"
    
    # TODO: Fix npm location, is now gone after pull
    run "cd #{current_path}; #{set_conf_path} npm install ; NODE_ENV=#{deploy_env} forever start server.js"
  end
  
  task :stop do
    puts "\n\nstopping `forever`; stopping `node`"
    run "killall forever ; killall node; true" # return true to continue running, even if exit code != 0
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.stop
    deploy.start
  end
end