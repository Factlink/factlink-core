#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'webrick'
require 'rack'
require 'yaml'

coredir = File.join(File.dirname(File.expand_path(__FILE__)),'..')

app = Rack::Builder.new do
  map '/lib/dist' do
    run Rack::Directory.new(File.join(coredir, 'js-library/output/dist'))
  end
end
Rack::Handler::Thin.run(app, :Port => 8000)
