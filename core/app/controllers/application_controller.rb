require 'net/http'
require 'action_controller/railtie'
require 'cancan'
require 'pavlov'

class ApplicationController < ActionController::Base

  include Pavlov::Helpers
  include Devise::Controllers::Rememberable

  DEFAULT_LAYOUT = 'frontend'

  def pavlov_options
    {
      current_user: current_user,
      ability: current_ability,
      time: Time.now,
      send_mails: true,
    }
  end

  def params_for_interactor(interactor_class)
    needed = (interactor_class.attribute_set.to_a.map(&:name) - [:pavlov_options]).map(&:to_s)
    Hash[params.select {|k,_| needed.include? k}]
  end

  def self.pavlov_action name, interactor_class
    define_method(name) do
      interactor_params = params_for_interactor(interactor_class).merge(pavlov_options: pavlov_options)

      render json: interactor_class.new(interactor_params).call
    end
  end

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

  def after_sign_in_path_for(user)
    safe_return_to_path || feed_path
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
  after_filter :set_access_control
  def set_access_control
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Origin'] = '*'
  end

  private

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
