class ApplicationController < ActionController::Base
  protect_from_forgery
  
  after_filter :set_access_control

  # before_filter :set_p3p_header  
  # def set_p3p_header
  #   response.headers['P3P'] = 'CP="CAO PSA OUR"'
  # end
  
  require 'twitter'
  require 'net/http'
  
  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

end