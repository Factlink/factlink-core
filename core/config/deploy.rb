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

set :user, "root"
set :use_sudo,    false

# Repository
set :scm, :git
set :repository,  "git@codebasehq.com:factlink/factlink/factlink-core.git"

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

ssh_options[:forward_agent] = true


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :all do
    set_conf_path="export CONFIG_PATH=#{deploy_to}/current; export NODE_ENV=#{deploy_env};"    
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :aptget do
    run "xargs apt-get install < #{File.join(release_path,'config','apt-requirements.txt')}"
  end
end

before "bundle:install", "deploy:aptget"

before 'deploy:all', 'deploy'
after 'deploy:all', 'deploy:restart'

after "deploy", "deploy:migrate"

