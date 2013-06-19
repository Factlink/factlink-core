#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'webrick'
require 'rack'
require 'yaml'

coredir = File.join(File.dirname(File.expand_path(__FILE__)),'..')
railsenv = ENV['RAILS_ENV'] || 'development'
yaml_file = File.join(coredir,'config/static.yml')
static_conf = YAML::load_file(yaml_file)[railsenv]['static']
serverport = static_conf['port']

#TODO save this in the static settings when we want to use this elsewhere
paths = [
  {:path => '/lib/dist',   :filepath => File.join(coredir, '../js-library/dist')},
  {:path => '/proxy', :filepath => File.join(coredir, '../web-proxy/static')},
  {:path => '/chrome', :filepath => File.join(coredir, '../chrome-extension/build')},
  {:path => '/extension/firefox', :filepath => File.join(coredir, '../firefox-extension/build')}
]



app = Rack::Builder.new do
  paths.each do |path|
    map path[:path] do
      run Rack::Directory.new(path[:filepath])
    end
  end
  map '/jslib' do
    jslibdir = Rack::Directory.new('../js-library/dist')
    lambda do |env|
      env['PATH_INFO'] = env['PATH_INFO'].gsub(/^\/[^\/]*/, '')
      jslibdir.call env
    end
  end
end
Rack::Handler::Thin.run(app, :Port => serverport)
