class SocialAccounts::BaseController < ApplicationController
  layout 'social_account_popup'

  def provider_name
    params[:provider_name]
  end

  def omniauth_obj
    request.env['omniauth.auth']
  end

  def trigger_event name, details=''
    render :'social_accounts/trigger_event', locals: {event: {name: name, details: details}}
  end
end
