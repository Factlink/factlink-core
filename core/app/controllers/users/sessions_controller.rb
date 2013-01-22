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

  before_filter :set_redir, only: :create
  before_filter :set_redir_after_fail, only: :new

  private
  def set_redir
    if params[:layout] == 'client'
      session[:redirect_after_failed_login_path] = new_user_session_path(layout:"client")
    else
      session[:return_to] = nil
    end
  end

  def set_redir_after_fail
    session[:redirect_after_failed_login_path] = new_user_session_path
  end
end
