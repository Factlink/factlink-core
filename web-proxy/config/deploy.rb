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



###

# ADD BUILD ON PRODUCTION

###


namespace :deploy do
  
  task :build do
  end
  
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    deploy.stop
    run set_conf_path + "NODE_ENV=testserver forever start server.js"
  end
  
  task :stop do
    run "killall forever ; killall node"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.stop
    deploy.start
  end
end


def set_conf_path
  "export CONFIG_PATH=#{deploy_to}/current/config/; export NODE_ENV=#{deploy_env};"
end