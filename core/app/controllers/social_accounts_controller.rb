require_relative 'application_controller'

class SocialAccountsController < ApplicationController
  # Got some inspiration from: http://www.communityguides.eu/articles/16

  layout 'social_popup'

  def callback
    omniauth_obj = request.env['omniauth.auth']
    @event_details = params[:provider_name]

    if user_signed_in?
      connect_provider params[:provider_name], omniauth_obj
    else
      sign_in_through_provider params[:provider_name], omniauth_obj
    end

    respond_to do |format|
      format.html { render :callback }
    end
  rescue Exception => error
    @event = "social_error"
    @event_details = error.message

    flash[:alert] = @event_details

    respond_to do |format|
      format.html { render :callback }
    end
  end

  def deauthorize
    case params[:provider_name]
    when 'facebook'
      provider_deauthorize 'facebook' do |uid, token|
        response = HTTParty.delete("https://graph.facebook.com/#{uid}/permissions?access_token=#{token}")
        if response.code != 200 and response.code != 400
          fail "Facebook deauthorize failed: '#{response.body}'."
        end
      end
    when 'twitter'
      provider_deauthorize 'twitter' do
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
    @event_details = "Authorization failed: #{params[:error_description]}."

    respond_to do |format|
      format.html { render :callback }
    end
  end

  private

  def connect_provider provider_name, omniauth_obj
    authorize! :update, current_user

    if is_connected_to_different_user(provider_name, omniauth_obj)
      fail "Already connected to a different account, please sign in to the connected account or reconnect your account."
    elsif omniauth_obj
      current_user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
      flash[:notice] = "Succesfully connected."
      @event = 'authorized'
    else
      fail "Error connecting."
    end
  end

  def is_connected_to_different_user provider_name, omniauth_obj
    social_account = current_user.social_account(provider_name)

    social_account.persisted? && social_account.uid != omniauth_obj['uid']
  end

  def sign_in_through_provider provider_name, omniauth_obj
    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account and social_account.user
      @user = social_account.user
      sign_in @user
      @event = 'signed_in'
    else
      @event = 'social_error'
      @event_details = "No connected #{provider_name.capitalize} account found. "+
                       "Please sign in with your credentials and connect your #{provider_name.capitalize} account."
    end
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
end
