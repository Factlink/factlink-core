class ApplicationController < ActionController::Base
  protect_from_forgery
  
  after_filter :set_access_control
  
  require 'twitter'
  require 'net/http'
  
  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

end