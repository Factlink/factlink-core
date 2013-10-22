require_relative 'application_controller'

class SocialAccountsController < ApplicationController
  # Got some inspiration from: http://www.communityguides.eu/articles/16

  def service_callback
    omniauth_obj = parse_omniauth_env provider_name

    if user_signed_in?
      connect_provider provider_name, omniauth_obj
    else
      sign_in_through_provider provider_name, omniauth_obj
    end

    respond_to do |format|
      format.html { render :callback, { layout: 'social_popup', locals: {event_details: @provider_name}}}
    end
  rescue Exception => error
    @event = "social_error"
    @error = error.message

    flash[:alert] = @error

    respond_to do |format|
      format.html { render :callback, { layout: 'social_popup', locals: {event_details: @error}}}
    end
  end

  def service_deauthorize
    case provider_name
    when 'facebook'
      provider_deauthorize provider_name do |uid, token|
        response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")
        if response.code != 200 and response.code != 400
          fail "Facebook deauthorize failed: '#{response.body}'."
        end
      end
    when 'twitter'
      provider_deauthorize provider_name do
        flash[:notice] = 'To complete, please deauthorize Factlink at the Twitter website.'
      end
    else
      fail "Wrong OAuth provider: #{omniauth['provider']}"
    end

    redirect_to edit_user_path(current_user)
  end

  def oauth_failure
    if params[:error_description].blank?
      params[:error_description] ||= "unspecified error"
    end
    @event = "social_error"
    @error = "Authorization failed: #{params[:error_description]}."

    respond_to do |format|
      format.html { render :callback, { layout: 'social_popup', locals: {event_details: @error}}}
    end
  end

  private

  def connect_provider provider_name, omniauth_obj
    authorize! :update, current_user

    if is_connected_to_different_user(provider_name, omniauth_obj)
      fail "Already connected to a different account, please sign in to the connected account or reconnect your account."
    elsif omniauth_obj
      current_user.social_account(provider_name).save_omniauth_obj!(omniauth_obj)
      flash[:notice] = "Succesfully connected."
      @event = 'authorized'
    else
      fail "Error connecting."
    end
  end

  def is_connected_to_different_user provider_name, omniauth_obj
    current_user.social_account(provider_name).different_from?(omniauth_obj)
  end

  def sign_in_through_provider provider_name, omniauth_obj
    social_account = SocialAccount.find_with_omniauth_obj(provider_name, omniauth_obj)

    if social_account and social_account.user
      @user = social_account.user
      sign_in @user
      @event = 'signed_in'
    else
      @event = 'social_error'
      @provider_name = "No connected #{provider_name.capitalize} account found. "+
                       "Please sign in with your credentials and connect your #{provider_name.capitalize} account."
    end
  end

  def parse_omniauth_env provider_name
    omniauth = request.env['omniauth.auth']
    fail "Wrong OAuth provider: #{omniauth['provider']}" if provider_name != omniauth['provider']
    fail 'Invalid omniauth object' unless omniauth['uid']

    if provider_name == 'twitter'
      omniauth['extra']['oath_version'] = omniauth['extra']['access_token'].consumer.options['oauth_version'];
      omniauth['extra']['signature_method'] = omniauth['extra']['access_token'].consumer.options['signature_method']
      omniauth['extra'].delete 'access_token'
    end

    omniauth
  end

  def provider_deauthorize provider_name, &block
    authorize! :update, current_user

    social_account = current_user.social_account(provider_name)

    if social_account.persisted?
      uid = social_account.omniauth_obj['uid']
      token = social_account.omniauth_obj['credentials']['token']

      begin
        block.call uid, token
        social_account.delete
        flash[:notice] ||= "Succesfully disconnected."
      rescue => e
        flash[:alert] = "Error disconnecting. #{e.message}"
      end
    else
      flash[:alert] = "Already disconnected."
    end
  end

  def provider_name
    @provider_name ||= params[:service]
  end
end
