# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
Rake.application.options.trace = true
require File.expand_path('../config/application', __FILE__)
require 'rake/dsl_definition'
require 'rake'

# Again deprecation warning
include Rake::DSL



FactlinkUI::Application.load_tasks