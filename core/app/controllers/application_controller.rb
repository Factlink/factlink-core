require 'net/http'
require 'action_controller/railtie'
require 'cancan'
require 'pavlov'

class ApplicationController < ActionController::Base

  include Pavlov::Helpers
  include Devise::Controllers::Rememberable

  DEFAULT_LAYOUT = 'frontend'

  def pavlov_options
    Util::PavlovContextSerialization.pavlov_context_by_user current_user, current_ability
  end

  # expose query to views, so we can rewrite inline
  # retrieval to proper queries. The queries should
  # be pulled back to controllers, and then to interactors
  helper_method :query # TODO: remove me ASAP

  rescue_from CanCan::AccessDenied, Pavlov::AccessDenied do |exception|
    respond_to do |format|
      if not current_user
        format.html do
          flash[:alert] = t('devise.failure.unauthenticated')
          redirect_to root_path(return_to: request.original_url)
        end
      end

      format.json { render json: {error: "You don't have the correct credentials to execute this operation", code: 'login'}, status: :forbidden }
      format.any  { fail exception }
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
    return setup_account_path unless user.set_up
    return start_the_tour_path unless seen_the_tour(user)

    safe_return_to_path || feed_path(current_user.username)
  end

  def safe_return_to_path
    return nil unless params[:return_to]

    uri = URI.parse(params[:return_to].to_s)
    if FactlinkUI::Application.config.hostname == uri.host
      uri.to_s
    else
      nil
    end
  end

  ##########
  # Set the Access Control, so XHR request from other domains are allowed.
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

  def current_graph_user
    return unless current_user
    @current_graph_user ||= current_user.graph_user
  end
  helper_method :current_graph_user

  def raise_404(message="Not Found")
    fail ActionController::RoutingError.new(message)
  end

  class HackAttempt < StandardError
  end

  rescue_from HackAttempt, with: :rescue_hacker

  def rescue_hacker
    render nothing: true, status: 500
  end

  def backbone_responder &block
    respond_to do |format|
      format.html do
        render inline: '', layout: 'frontend_with_backbone'
      end
      format.json { yield } if block_given?
    end
  end

  private

  def can_haz feature
    can? :"see_feature_#{feature}", Ability::FactlinkWebapp
  end
  helper_method :can_haz

  def inject_special_test_code
    # this method is used by the test to inject things like the
    # test_counter (aka cross-test-request-forgery prevention), and
    # possibly eventually custom styling for poltergeist screenshots.
  end
  helper_method :inject_special_test_code

  def remembered_sign_in user, options={}
    sign_in user, options
    remember_me user
  end
end
