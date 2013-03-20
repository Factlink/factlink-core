require 'net/http'
require 'action_controller/railtie'
require 'cancan'
require 'pavlov'

class ApplicationController < ActionController::Base

  include Pavlov::Helpers

  DEFAULT_LAYOUT = 'frontend'

  def pavlov_options
    {
      current_user: current_user,
      ability: current_ability,
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

  rescue_from CanCan::AccessDenied, Pavlov::AccessDenied do |exception|
    respond_to do |format|
      if not current_user
        format.html { redirect_to root_path(return_to: request.original_url, show_sign_in: 1)}
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

  def seen_the_tour user
    view_context.tour_steps.last.to_s == user.seen_tour_step
  end

  def start_the_tour_path
    step = current_user.seen_tour_step || view_context.first_real_tour_step

    send(:"#{step}_path")
  end

  def after_sign_in_path_for(user)
    if seen_the_tour(user)
      safe_return_to_path || channel_activities_path(user, user.graph_user.stream)
    elsif user.agrees_tos
      start_the_tour_path
    else
      tos_path
    end
  end

  def safe_return_to_path
    uri = URI.parse(return_to_path.to_s)
    if FactlinkUI::Application.config.hostname == uri.host
      uri.to_s
    else
      nil
    end
  end

  def return_to_path
    if params[:return_to]
      params[:return_to]
    elsif request.env['omniauth.origin']
      query_params = QueryParams.new(request.env['omniauth.origin'])
      query_params[:return_to]
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

  def jslib_url
    FactlinkUI::Application.config.jslib_url
  end
  helper_method :jslib_url

  private
    def action_is_intermediate?
      action_name == "intermediate" and controller_name == "facts"
    end

    def can_haz feature
      can? :"see_feature_#{feature}", Ability::FactlinkWebapp
    end
    helper_method :can_haz

    def set_layout
      allowed_layouts = ['popup', 'client']
      allowed_layouts.include?(params[:layout]) ? @layout = params[:layout] : @layout = self.class::DEFAULT_LAYOUT
    end
end
