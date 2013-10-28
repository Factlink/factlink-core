class SocialAccounts::RegistrationsController < ApplicationController
  layout 'social_account_popup'

  def callback
    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account and social_account.user
      @user = social_account.user
      sign_in @user
      @event = { name: 'signed_in' }

      render :'social_accounts/callback'
    else
      social_account.delete if social_account # TODO: update existing one
      @social_account = SocialAccount.create! provider_name: provider_name, omniauth_obj: omniauth_obj
      @user = User.new

      render :'social_accounts/registrations/sign_up_or_in'
    end
  rescue Exception => error
    @event = { name: "social_error", details: error.message }
    render :'social_accounts/callback'
  end

  def sign_up_or_in
    @social_account = SocialAccount.find(params[:user][:social_account_id])

    email = params[:user][:email]
    password = params[:user][:password]

    @user = sign_in_and_connect_existing_user(email, password) ||
      sign_up_new_user(email, password, @social_account.name)

    if @user.errors.empty?
      @user.social_accounts.push @social_account
      sign_in(@user)
      @event = { name: 'signed_in' }
      render :'social_accounts/callback'
    else
      render :'social_accounts/registrations/sign_up_or_in'
    end
  end

  private

  def sign_in_and_connect_existing_user email, password
    return if email.blank?
    return unless User.find_by(email: email)

    user_authenticated_with_warden(email, password) ||
      user_with_wrong_password(email)
  end

  def user_with_wrong_password email
    user = User.new
    user.email = email
    user.errors.add(:password, 'incorrect password for existing account')
    user
  end

  # TODO: iets van een comment
  def user_authenticated_with_warden email, password
    # TODO: heen en terug?
    params[:user][:login] = email
    params[:user][:password] = password
    allow_params_authentication!

    warden.authenticate(scope: :user)
  end

  def sign_up_new_user email, password, full_name
    user = User.new password: password,
      password_confirmation: password,
      full_name: full_name

    # Protected from mass-assignment
    user.email = email
    user.set_up = true
    user.generate_username!

    user.save

    user
  end

  def provider_name
    params[:provider_name]
  end

  def omniauth_obj
    request.env['omniauth.auth']
  end
end
