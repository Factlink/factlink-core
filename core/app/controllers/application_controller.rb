require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all
  
  after_filter :set_access_control
  
  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

  def after_sign_in_path_for(resource)
    user_profile_path(resource.username)
  end
  
  def current_graph_user
    current_user.andand.graph_user
  end

  def mustache_json(klass)
    #ripped from mustache itself
    mustache = klass.new
    variables = self.instance_variable_names
    variables -= %w[@template]

    if self.respond_to?(:protected_instance_variables)
      variables -= self.protected_instance_variables
    end

    variables.each do |name|
      mustache.instance_variable_set(name, self.instance_variable_get(name))
    end

    # Declaring an +attr_reader+ for each instance variable in the
    # Mustache::Rails subclass makes them available to your templates.
    mustache.class.class_eval do
      attr_reader *variables.map { |name| name.sub(/^@/, '').to_sym }
    end

    mustache.to_json
  end

end