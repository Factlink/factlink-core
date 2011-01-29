class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require "twitter"
end
