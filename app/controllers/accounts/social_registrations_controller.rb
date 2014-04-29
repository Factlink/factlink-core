class Accounts::SocialRegistrationsController < Accounts::BaseController
  around_filter :render_trigger_event_on_social_account_error

  def callback
    social_account = SocialAccount.find_by_provider_and_uid(provider_name, omniauth_obj['uid'])

    if social_account and social_account.user
      @user = social_account.user
      remembered_sign_in @user

      render_success_event
    else
      if social_account # spurious account
        social_account.destroy
      end

      @social_account = SocialAccount.new provider_name: provider_name
      @social_account.update_omniauth_obj! omniauth_obj
      session[:register_social_account_id] = @social_account.id.to_s

      @user = User.new
      @user.email = @social_account.email

      render :'accounts/social_registrations/new'
    end
  end

  def create
    @social_account = SocialAccount.find(session[:register_social_account_id]) rescue (raise AccountError)

    # Potential hack attempt or strange race condition
    fail AccountError unless @social_account
    fail AccountError if @social_account.user

    email = params[:user][:email]
    password = params[:user][:password] || random_password

    sign_in_and_connect_existing_user(email, password) ||
      sign_up_new_user(email, password, @social_account.name)
  end

  private

  def random_password
    SecureRandom.base64(22) # Largest password accepted by Devise
  end

  def finish_connecting
    @social_account.user = @user
    @social_account.save!
    remembered_sign_in(@user)

    render_success_event
  end

  def sign_in_and_connect_existing_user email, password
    return if email.blank?
    return unless User.where(email: email).first

    @user = user_authenticated_with_warden(email, password) ||
      user_with_wrong_password(email)

    if @user.errors.empty?
      finish_connecting
    else
      @alternative_provider_name = alternative_provider_name_for User.where(email: email).first

      render :'accounts/social_registrations/existing'
    end
  end

  def alternative_provider_name_for user
    other_social_account = user.social_accounts.first
    return nil unless other_social_account
    return nil if other_social_account.provider_name == @social_account.provider_name

    other_social_account.provider_name
  end

  def user_with_wrong_password email
    user = User.new
    user.email = email
    user.errors.add(:password, 'enter password for existing account')
    user
  end

  # As far as we know, this is the only way to authenticate
  # with warden using the devise strategies, using params.
  # Therefore we set the params, authenticate, and then restore them.
  def user_authenticated_with_warden email, password
    user = User.where(email: email).first
    if user && user.valid_password?(password)
      user
    else
      nil
    end
  end

  def sign_up_new_user email, password, full_name
    @user = User.new password: password,
                    password_confirmation: password,
                    full_name: full_name

    # Protected from mass-assignment
    @user.email = email
    @user.generate_username!

    @user.save

    if @user.errors.empty?
      finish_connecting
    else
      render :'accounts/social_registrations/new'
    end
  end
end
