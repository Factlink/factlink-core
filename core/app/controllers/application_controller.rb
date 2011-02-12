class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'twitter'
  require 'net/http'
end
