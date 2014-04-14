require 'appsignal/capistrano'

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

namespace :action do

  task :start_resque do
    run "sudo monit start resque"
  end

  task :stop_resque do
    run "sudo monit stop resque"
  end

  task :stop_background_processes do
    run "#{current_path}/bin/server/stop_background_scripts.sh"
  end

end

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

  task :check_installed_packages do
    run "sh #{current_release}/bin/server/check_installed_packages.sh"
  end

  # end

  #
  #  Only precompile if files have changed
  #
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end
end

namespace :mongoid do
  task :create_indexes do
    run "cd #{current_path}; #{rake} db:mongoid:create_indexes"
  end
end

before 'deploy:all',      'deploy'
after 'deploy:all',       'deploy:restart'

before 'deploy:migrate',  'action:stop_background_processes'

after 'deploy',           'deploy:migrate'

after 'deploy:migrate',   'action:start_resque'

after 'deploy:update',    'deploy:check_installed_packages'

after 'deploy:check_installed_packages', 'deploy:cleanup'

require './config/boot'
