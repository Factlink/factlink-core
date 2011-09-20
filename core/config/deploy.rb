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

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last
after "deploy", "deploy:migrate"

ssh_options[:forward_agent] = true


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :all do
    set_conf_path='export CONFIG_PATH=#{deploy_to}/current/config/; export NODE_ENV=#{deploy_env};'
    # Update the static files
    run set_conf_path + 'cd /applications/factlink-js-library/ && git checkout #{branch} && git pull origin #{branch}'

    # Update the static files
    run set_conf_path + 'cd /applications/factlink-chrome-extension/ && git checkout #{branch} && git pull origin #{branch} && ./release_repo.sh'
    
    # Update the Proxy
    # don't use && chained with killall
    # TODO we should add a proper workaround
    run set_conf_path + "cd /applications/web-proxy && git checkout #{branch} && git pull origin #{branch} && killall forever ; killall node ; NODE_ENV=testserver forever start server.js "
    
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:all', 'deploy'
after 'deploy', 'deploy:restart'