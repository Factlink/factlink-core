class SocialAccounts::ConnectionsController < ApplicationController
  layout 'social_account_popup'

  def callback
    connect_provider params[:provider_name], request.env['omniauth.auth']

    render :'social_accounts/callback'
  rescue Exception => error
    @event = { name: "social_error", details: error.message }
  end

  def deauthorize
    authorize! :update, current_user

    deauthorize_social_account current_user.social_account(params[:provider_name])
  rescue Exception => error
    flash[:alert] = "Error disconnecting: #{error.message}"
  ensure
    redirect_to edit_user_path(current_user)
  end

  def oauth_failure
    if params[:error_description].blank?
      params[:error_description] ||= "unspecified error"
    end

    @event = { name: "social_error", details: "Authorization failed: #{params[:error_description]}." }

    render :'social_accounts/callback'
  end

  private

  def connect_provider provider_name, omniauth_obj
    authorize! :update, current_user

    if is_connected_to_different_user(provider_name, omniauth_obj)
      fail "Already connected to a different account, please sign in to the connected account or reconnect your account."
    elsif omniauth_obj
      current_user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
      flash[:notice] = "Succesfully connected."
      @event = { name: 'authorized', details: provider_name }
    else
      fail "Error connecting."
    end
  end

  def is_connected_to_different_user provider_name, omniauth_obj
    social_account = current_user.social_account(provider_name)

    social_account.persisted? && social_account.uid != omniauth_obj['uid']
  end

  def deauthorize_social_account social_account
    fail "Already disconnected." unless social_account.persisted?

    case social_account.provider_name
    when 'facebook'
      deauthorize_facebook social_account
    when 'twitter'
      deauthorize_twitter social_account
    end
  end

  def deauthorize_facebook social_account
    uid = social_account.omniauth_obj['uid']
    token = social_account.omniauth_obj['credentials']['token']
    response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")
    fail response.body if response.code != 200 and response.code != 400

    social_account.delete
    flash[:notice] = "Succesfully disconnected."
  end

  def deauthorize_twitter social_account
    social_account.delete
    flash[:notice] = 'To complete, please deauthorize Factlink at the Twitter website.'
  end
end
