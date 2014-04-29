require 'appsignal/capistrano'

# Show only important output
logger.level = Logger::IMPORTANT

#############
# Application
set :application, "core"
set :keep_releases, 10

########
# Stages
set :stages, %w(staging production)
require 'capistrano/ext/multistage'

#################
# Bundler support
require "bundler/capistrano"
set :bundle_flags, "--deployment --quiet --binstubs"

set :user, "deploy"
set :use_sudo,    false

# Repository
set :scm, :none
set :repository,  "."

set :deploy_to, "/applications/#{application}"
set :deploy_via, :copy    # only fetch changes since since last
set :copy_exclude, %w(tmp spec log)

ssh_options[:forward_agent] = true

set :default_environment, {
  PATH: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

namespace :deploy do
  task :all do
    set_conf_path="export CONFIG_PATH=#{deploy_to}/current; export NODE_ENV=#{deploy_env};"
  end

  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  #
  #  Only precompile if files have changed
  #
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end
end

$stdout.sync = true

before 'deploy:all',      'deploy'
after 'deploy:all',       'deploy:restart'

after 'deploy',           'deploy:migrate'

after 'deploy:check_installed_packages', 'deploy:cleanup'

before "deploy:update_code" do
  print "Updating Code........"
end

after "deploy:update_code" do
  puts "Done."
end

before "deploy:migrate" do
  print "Migrating.........."
end

after "deploy:migrate" do
  puts "Done."
end

before "deploy:cleanup" do
  print "Cleaning Up.........."
end

after "deploy:cleanup" do
  puts "Done."
end

require './config/boot'
