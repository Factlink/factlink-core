# Stages
set :stages, %w(testserver production)
set :default_stage, "testserver"
require 'capistrano/ext/multistage'

# Application
set :application, "factlink-core"

# Repository
set :scm, :git
set :repository,  "git@codebasehq.com:factlink/factlink/factlink-core.git"

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

role :web, "nginx"                          # Your HTTP server, Apache/etc
role :app, "nginx"                          # This may be the same as your `Web` server
# role :db,  "mongodb", :primary => true # This is where Rails migrations will run

task :uname do
  run "uname -a"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end