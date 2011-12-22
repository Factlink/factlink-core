#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'webrick'
require 'rack'

coredir = File.join(File.dirname(File.expand_path(__FILE__)),'..')
railsenv = ENV['RAILS_ENV'] || 'development'
static_conf = YAML::load_file(File.join(coredir,'config/static.yml'))[railsenv]['static']
serverport = static_conf['port']

#TODO save this in the static settings when we want to use this elsewhere
paths = [
  {:path => '/lib',   :filepath => File.join(coredir, '../factlink-js-library')},
  {:path => '/proxy', :filepath => File.join(coredir, '../web-proxy/static')}
]



app = Rack::Builder.new do
  paths.each do |path|
    map path[:path] do
      run Rack::Directory.new(path[:filepath])
    end
  end
end
Rack::Handler::Thin.run(app, :Port => serverport)
