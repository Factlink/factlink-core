#############
# Application
set :application, "js-library"
set :keep_releases, 10

########
# Stages
set :stages, %w(vagrant testserver staging production)
require 'capistrano/ext/multistage'

set :user, "deploy"
set :use_sudo,    false

# Repository
set :scm, :git
set :repository,  "git@github.com:Factlink/js-library.git"
set :git_enable_submodules, 1

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

ssh_options[:forward_agent] = true

# don't touch all static files:
set :normalize_asset_timestamps, false


namespace :deploy do
  task :build do
    run "cd #{current_path}; npm install; grunt server;"
  end
end

after "deploy", "deploy:build"
after 'deploy:update', 'deploy:cleanup'
