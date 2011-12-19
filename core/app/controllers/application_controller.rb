require 'net/http'

class ApplicationController < ActionController::Base

  # before_filter :checkie_checkie
  def checkie_checkie
    unless is_a?(Devise::SessionsController) || is_a?(TosController)
      if current_user.andand.agrees_tos == false
        redirect_to tos_path
      end
    end
  end

  include UrlHelper
  before_filter :set_mailer_url_options
  
  #require mustache partial views (the autoloader does not find them)
  Dir["#{Rails.root}/app/views/**/_*.rb"].each do |path| 
    require_dependency path 
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: {error: "You don't have the correct credentials to execute this operation"}, status: :forbidden }
      format.any  { raise exception }
    end
  end

  around_filter :profile
  
  def profile
    return yield if ((params[:profile].nil?) || (Rails.env != 'development'))
    result = RubyProf.profile { yield }
    printer = RubyProf::GraphPrinter.new(result)
    out = StringIO.new
    printer.print(out,{})
    response.body = out.string
    response.content_type = "text/plain"
  end

  protect_from_forgery
  
  helper :all
  
  after_filter :set_access_control
  
  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end
  
  def current_graph_user
    @current_graph_user ||= current_user.andand.graph_user
  end
  
  def raise_404(message="Not Found")
    raise ActionController::RoutingError.new(message)
  end
end