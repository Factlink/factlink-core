require 'net/http'

class ApplicationController < ActionController::Base

  include UrlHelper
  before_filter :set_mailer_url_options

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
      elsif !current_user.agrees_tos
        format.html { redirect_to tos_path }
        format.json { render json: {error: "You did not agree to the Terms of Service."}, status: :forbidden }
        format.any  { raise exception }
      else
        format.json { render json: {error: "You don't have the correct credentials to execute this operation"}, status: :forbidden }
        format.any  { raise exception }
      end
    end
  end

  protect_from_forgery

  helper :all

  after_filter :set_access_control


  def after_sign_in_path_for(user)
    return_to = session[:return_to]
    session[:return_to] = nil

    return return_to || stored_location_for(user) ||
      if can_haz :discovery_tab_all_stream
        activities_channel_path(user, user.graph_user.stream)
      else
        channel_path(user, user.graph_user.stream)
      end
  end

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
                     :distinct_id => current_user.id,
                     :time => Time.now.utc.to_i })
                else
                  opts
                end

    req_env = MixpanelRequestPresenter.new(request).to_hash

    username = current_user ? current_user.username : nil
    user_id  = current_user ? current_user.id : nil

    Resque.enqueue(MixpanelTrackEventJob, event, new_opts, req_env, user_id, username)
  end

  private
  def channels_for_user(user)
    @channels = user.graph_user.channels
    unless @user == current_user
      @channels = @channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 || ch.type != 'channel'}
    end
    @channels
  end
  helper_method :channels_for_user

  def can_haz feature
    can? :"see_feature_#{feature}", Ability::FactlinkWebapp
  end
  helper_method :can_haz

  def set_layout
    allowed_layouts = ['popup']
    allowed_layouts.include?(params[:layout]) ? @layout = params[:layout] : @layout = 'frontend'
  end

end