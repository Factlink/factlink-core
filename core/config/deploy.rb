require 'new_relic/recipes'

#############
# Application
set :application, "core"
set :keep_releases, 10

########
# Stages
set :stages, %w(testserver staging production)
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
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_type, :system

set :user, "deploy"
set :use_sudo,    false

# Repository
set :scm, :git
set :repository,  "git@github.com:Factlink/core.git"

set :deploy_to, "/applications/#{application}"
set :deploy_via, :remote_cache    # only fetch changes since since last

ssh_options[:forward_agent] = true


namespace :action do

  task :start_recalculate do
    run "sh #{current_path}/bin/server/start_recalculate_using_monit.sh"
  end
  task :stop_recalculate do
    run "sh #{current_path}/bin/server/stop_recalculate.sh"
  end

  task :start_resque do
    run "sh #{current_path}/bin/server/start_resque_using_monit.sh"
  end
  task :stop_resque do
    run "sudo /usr/sbin/monit stop resque"
  end

end

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

  task :check_installed_packages do
    run "sh #{current_release}/bin/server/check_installed_packages.sh"
  end

  task :curl_site do
    run <<-CMD
      curl --user deploy:sdU35-YGGdv1tv21jnen3 #{full_url} > /dev/null
    CMD
  end

  #
  #  Only precompile if files have changed
  #
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      # Only precompile if files have changed: http://www.bencurtis.com/2011/12/skipping-asset-compilation-with-capistrano/
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ app/backbone/ app/templates/ Gemfile.lock config/application.rb config/deploy.rb config/deploy/ config/locales | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile:primary}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
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

before 'deploy:migrate',  'action:stop_recalculate'
before 'deploy:migrate',  'action:stop_resque'

after 'deploy',           'deploy:migrate'

after 'deploy:migrate',   'action:start_recalculate'
after 'deploy:migrate',   'action:start_resque'

after 'deploy:update',    'deploy:check_installed_packages'
after 'deploy:check_installed_packages', 'deploy:cleanup'

after 'deploy',           'deploy:curl_site'

require './config/boot'
