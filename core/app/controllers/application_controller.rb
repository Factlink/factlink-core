class ApplicationController < ActionController::Base
  protect_from_forgery
  
  after_filter :set_access
  
  require 'twitter'
  require 'net/http'
  
  def set_access
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end
  
  
end
