require 'net/http'

class ApplicationController < ActionController::Base

  include Pavlov::Helpers
  def pavlov_options
    {
      current_user: current_user,
      mixpanel: FactlinkUI::Application.config.mixpanel.new({}, true)
    }
  end

  before_filter :check_preferred_browser
  def check_preferred_browser
    if current_user
      message = :supported_browser_warning

      supported_browser = (view_context.browser_supported? and (not view_context.browser_preferred?))
      allowed_controller = (not ["tour", "tos"].include? controller_name)

      if supported_browser and allowed_controller
        if not current_user.seen_messages.include? message.to_s
          @show_supported_browser_warning = true
        end
      end
    end
  end

  #require mustache partial views (the autoloader does not find them)
  Dir["#{Rails.root}/app/views/**/_*.rb"].each do |path|
    require_dependency path
  end

  rescue_from CanCan::AccessDenied, Pavlov::AccessDenied do |exception|
    respond_to do |format|
      if not current_user
        format.html { redirect_to new_user_session_path }
        format.json { render json: {error: "You don't have the correct credentials to execute this operation", code: 'login'}, status: :forbidden }
        format.any  { raise exception }
      elsif !current_user.agrees_tos
        format.html { redirect_to tos_path }
        format.json { render json: {error: "You did not agree to the Terms of Service.", code: 'tos'}, status: :forbidden }
        format.any  { raise exception }
      else
        format.json { render json: {error: "You don't have the correct credentials to execute this operation", code: 'login'}, status: :forbidden }
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

    return_to || stored_location_for(user) || channel_activities_path(user, user.graph_user.stream)
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

  def render_backbone_page
    render inline:'', layout: 'channels'
  end

  def backbone_responder &block
    respond_to do |format|
      format.html { render_backbone_page }
      format.json { yield } if block_given?
    end
  end


  def lazy *args, &block
    Lazy.new(*args, &block)
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

    Resque.enqueue(Mixpanel::TrackEventJob, event, new_opts, req_env)
  end

  def track_people_event(opts={})
    if current_user
      req_env = MixpanelRequestPresenter.new(request).to_hash
      Resque.enqueue(Mixpanel::TrackPeopleEventJob, current_user.id, opts, req_env)
    end
  end

  before_filter :track_click
  def track_click
    unless params[:ref].blank?
      ref = params[:ref]
      if ['extension_skip', 'extension_next'].include?(ref)
        track "#{ref} click".capitalize
      end
    end

  end

  before_filter :initialize_mixpanel
  def initialize_mixpanel
    @mixpanel = FactlinkUI::Application.config.mixpanel.new(request.env, true)

    if action_is_intermediate?
      @mixpanel.append_api('disable', ['mp_page_view'])
    end

    if current_user
      @mixpanel.append_api('name_tag', current_user.username)
      @mixpanel.append_identify(current_user.id.to_s)
    end
  end

  before_filter :set_last_interaction_for_user
  def set_last_interaction_for_user
    if user_signed_in? and not action_is_intermediate? and request.format == "text/html"
      track_people_event last_interaction_at: DateTime.now
      Resque.enqueue(SetLastInteractionForUser, current_user.id, DateTime.now.to_i)
    end
  end


  def jslib_url_for(username)
    FactlinkUI::Application.config.jslib_url_builder.url_for username
  end
  helper_method :jslib_url_for

  private
    def action_is_intermediate?
      action_name == "intermediate" and controller_name == "facts"
    end

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
      allowed_layouts = ['popup', 'client']
      allowed_layouts.include?(params[:layout]) ? @layout = params[:layout] : @layout = 'frontend'
    end



end
