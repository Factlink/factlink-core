class Accounts::FactlinkAccountsController < Accounts::BaseController
  around_filter :render_trigger_event_on_social_account_error

  def new
    @user_new_session = User.new
    @user_new_account = User.new
  end

  def create_session
    @user_new_session = parse_user_new_session(params[:user_new_session] || {})

    if @user_new_session.errors.empty?
      remembered_sign_in(@user_new_session)

      render_trigger_event 'signed_in', ''
    else
      @user_new_account = User.new
      render :'accounts/factlink_accounts/new'
    end
  end

  def create_account
    @user_new_account = parse_user_new_account(params[:user_new_account] || {})

    if @user_new_account.save
      remembered_sign_in(@user_new_account)

      render_trigger_event 'signed_in', ''
    else
      @user_new_session = User.new
      render :'accounts/factlink_accounts/new'
    end
  end

  private

  # As far as we know, this is the only way to authenticate
  # with warden using the devise strategies, using params.
  # Therefore we set the params, and authenticate.
  def parse_user_new_session(user_params)
    params[:user] = user_params
    allow_params_authentication!

    unless user = warden.authenticate(scope: :user)
      user = User.new
      user.errors.add :login, 'incorrect email address or password'
    end

    user
  end

  def parse_user_new_account(user_params)
    user = User.new user_params.slice :password,
      :password_confirmation, :full_name

    # Protected from mass-assignment
    user.email = user_params[:email]
    user.set_up = true
    user.generate_username!

    user
  end
end
