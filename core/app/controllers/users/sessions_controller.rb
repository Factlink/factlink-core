class Users::SessionsController < Devise::SessionsController

  DEFAULT_LAYOUT = "user_session"

  layout :set_layout

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out; track "Sign out"; end
  def track_sign_in
    track_people_event sign_in_count: current_user.sign_in_count
    track "Sign in"
  end

  before_filter :set_layout, only: :new

  before_filter :set_redirect_to_be_used_after_failed_login, only: :new

  # remove this entire method when removing :act_as_non_signed_in
  def require_no_authentication
    user = warden.user("user")
    if params[:layout] == 'client' and user and user.features.include? :act_as_non_signed_in
      # do nothing and show the login screen
    else
      super
    end
  end
end
