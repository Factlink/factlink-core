class SocialAccounts::BaseController < ApplicationController
  layout 'social_account_popup'

  def provider_name
    params[:provider_name]
  end

  def omniauth_obj
    request.env['omniauth.auth']
  end

  def render_trigger_event name, details=''
    render :'social_accounts/trigger_event', locals: {event: {name: name, details: details}}
  end

  def render_trigger_event_on_social_account_error
    yield
  rescue SocialAccountError => error
    if error.message == SocialAccountError.new.message
      render_trigger_event 'social_error', "Something went wrong"
    else
      render_trigger_event 'social_error', error.message
    end
  end

  class SocialAccountError < StandardError
  end
end
