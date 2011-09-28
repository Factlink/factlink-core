class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all
  
  after_filter :set_access_control
  
  require 'twitter'
  require 'net/http'
  
  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

  def after_sign_in_path_for(resource)

    if session[:"user.return_to"].nil?
      return user_profile_path(@current_user.username)
    else
      return view_context.url_for(fact_path(session[:"user.return_to"].to_s))
    end
  end

end