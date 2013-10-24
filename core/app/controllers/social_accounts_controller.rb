require_relative 'application_controller'

class SocialAccountsController < ApplicationController
  layout 'social_account_popup'

  def callback
    omniauth_obj = request.env['omniauth.auth']

    if user_signed_in?
      connect_provider params[:provider_name], omniauth_obj
    else
      sign_in_through_provider params[:provider_name], omniauth_obj
    end
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

    render :callback
  end

  def sign_up_or_in
    @social_account = SocialAccount.find(params[:user][:social_account_id])

    @user = User.new
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]

    sign_in_and_connect_existing_user(@user, @social_account) or sign_up_new_user(@user, @social_account)
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

  def sign_in_through_provider provider_name, omniauth_obj
    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account and social_account.user
      @user = social_account.user
      sign_in @user
      @event = { name: 'signed_in' }
    else
      social_account.delete if social_account
      new_social_account(provider_name, omniauth_obj)
    end
  end

  def new_social_account provider_name, omniauth_obj
    @social_account = SocialAccount.create! provider_name: provider_name, omniauth_obj: omniauth_obj
    @user = User.new

    render :sign_up_or_in
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

  def sign_in_and_connect_existing_user user, social_account
    return false if user.email.blank?
    return false unless User.find_by(email: user.email)

    params[:user][:login] = user.email
    params[:user][:password] = user.password
    allow_params_authentication!

    authenticated_user = warden.authenticate(scope: :user)

    if authenticated_user
      authenticated_user.social_accounts.push social_account
      sign_in(authenticated_user)

      @event = { name: 'signed_in' }
      render :callback
    else
      user.errors.add(:password, 'incorrect password for existing account')
    end

    true
  end

  def sign_up_new_user user, social_account
    user.password_confirmation = params[:user][:password]
    user.full_name = social_account.name
    user.generate_username!

    if user.save
      user.social_accounts.push social_account

      sign_in(user)
      @event = { name: 'signed_in' }
      render :callback
    end
  end
end
