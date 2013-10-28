class SocialAccounts::RegistrationsController < SocialAccounts::BaseController
  def callback
    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account and social_account.user
      @user = social_account.user
      sign_in @user

      render_trigger_event 'signed_in'
    else
      social_account.delete if social_account # TODO: update existing one

      @social_account = SocialAccount.create! provider_name: provider_name, omniauth_obj: omniauth_obj
      session[:register_social_account_id] = @social_account.id.to_s

      @user = User.new

      render :'social_accounts/registrations/new'
    end
  rescue Exception => error
    render_trigger_event 'social_error', error.message
  end

  def create
    begin
      @social_account = SocialAccount.find(session[:register_social_account_id])
    rescue
      raise SocialAccountError
    end

    # Potential hack attempt or strange race condition
    fail SocialAccountError unless @social_account
    fail SocialAccountError if @social_account.user

    email = params[:user][:email]
    password = params[:user][:password]

    @user = sign_in_and_connect_existing_user(email, password) ||
      sign_up_new_user(email, password, @social_account.name)

    if @user.errors.empty?
      @user.social_accounts.push @social_account
      sign_in(@user)

      render_trigger_event 'signed_in'
    else
      render :'social_accounts/registrations/new'
    end
  rescue SocialAccountError => error
    message = error.message == SocialAccountError.new.message ? "Something went wrong" : error.message
    render_trigger_event 'social_error', message
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

  # As far as we know, this is the only way to authenticate
  # with warden using the devise strategies, using params.
  # Therefore we set the params, authenticate, and then restore them.
  def user_authenticated_with_warden email, password
    previous_login = params[:user][:login]
    previous_password = params[:user][:password]
    params[:user][:login] = email
    params[:user][:password] = password

    allow_params_authentication!
    user = warden.authenticate(scope: :user)

    params[:user][:login] = previous_login
    params[:user][:password] = previous_password

    user
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
end
