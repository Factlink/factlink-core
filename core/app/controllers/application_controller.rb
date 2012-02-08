require 'net/http'

class ApplicationController < ActionController::Base

  include UrlHelper
  before_filter :set_mailer_url_options, :initialize_mixpanel

  def initialize_mixpanel
    @mixpanel = FactlinkUI::Application.config.mixpanel.new(request.env, true)

    @mixpanel.append_api(:identify, current_user.id) if current_user
    @mixpanel.append_api(:name_tag, current_user.username) if current_user
  end

  #require mustache partial views (the autoloader does not find them)
  Dir["#{Rails.root}/app/views/**/_*.rb"].each do |path|
    require_dependency path
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      if not current_user
        format.html { redirect_to new_user_session_path }
        format.json { render json: {error: "You don't have the correct credentials to execute this operation"}, status: :forbidden }
        format.any  { raise exception }
      elsif current_user.agrees_tos
        format.html { redirect_to tos_path }
        format.json { render json: {error: "You did not agree to the Terms of Service."}, status: :forbidden }
        format.any  { raise exception }
      else
        format.json { render json: {error: "You don't have the correct credentials to execute this operation"}, status: :forbidden }
        format.any  { raise exception }
      end
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

  class HackAttempt < StandardError
  end
  rescue_from HackAttempt, with: :rescue_hacker

  def rescue_hacker
    render nothing: true, status: 500
  end

  def lazy *args, &block
    Lazy.new *args, &block
  end

  def track(event, opts={})
    new_opts =  if current_user
                   opts.update({
                     :mp_name_tag => current_user.username,
                     :distinct_id => current_user.id })
                else
                  opts
                end
    @mixpanel.track_event event, new_opts
  end

end