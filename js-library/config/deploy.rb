#############
# Application
set :application, "factlink-js-library"

########
# Stages
set :stages, %w(testserver staging production)
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
set :repository,  "git@codebasehq.com:factlink/factlink/factlink-js-library.git"
set :git_enable_submodules, 1

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

ssh_options[:forward_agent] = true

# don't tuch all static files:
set :normalize_asset_timestamps, false


###

# ADD BUILD ON PRODUCTION

###


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy", "deploy:build"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :build do
    run "cd #{current_path}; make"
  end
  
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
end