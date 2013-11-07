class Accounts::BaseController < ApplicationController
  layout 'accounts_popup'

  def provider_name
    params[:provider_name]
  end

  def omniauth_obj
    request.env['omniauth.auth']
  end

  def render_trigger_event name, details
    render :'accounts/trigger_event', locals: {event: {name: name, details: details}}
  end

  def render_trigger_event_on_social_account_error
    yield
  rescue AccountError => error
    render_trigger_event 'social_error', error.message
  end

  class AccountError < StandardError
    def initialize(msg = 'Something went wrong')
      super
    end
  end
end
