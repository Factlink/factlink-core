#############
# Application
set :application, "js-library"
set :keep_releases, 10

########
# Stages
set :stages, %w(staging production)
require 'capistrano/ext/multistage'

set :user, "deploy"
set :use_sudo,    false

# Repository
set :scm, :none
set :repository,  "./output"

set :deploy_to, "/applications/#{application}"
set :deploy_via, :copy    # only fetch changes since since last

ssh_options[:forward_agent] = true

# don't touch all static files:
set :normalize_asset_timestamps, false

after 'deploy:update', 'deploy:cleanup'
