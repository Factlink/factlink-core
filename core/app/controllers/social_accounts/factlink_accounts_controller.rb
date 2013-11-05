class SocialAccounts::FactlinkAccountsController < SocialAccounts::BaseController
  around_filter :render_trigger_event_on_social_account_error

  def new
    @user_new_session = User.new
    @user_new_account = User.new
  end
end
