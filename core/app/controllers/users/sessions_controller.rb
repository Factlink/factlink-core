class Users::SessionsController < Devise::SessionsController

  DEFAULT_LAYOUT = "user_session"

  layout :set_layout

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out; track "Sign out"; end
  def track_sign_in; track "Sign in"; end

  before_filter :set_layout, only: :new

  before_filter :set_redir, only: :create
  before_filter :set_redir_after_fail, only: :new

  private
  def set_redir
    if params[:layout] == 'client'
      session[:just_signed_in] = true
      session[:redirect_after_failed_login_path] = new_user_session_path(layout:"client")
    else
      session[:return_to] = nil
      session[:just_signed_in] = nil
    end
  end

  def set_redir_after_fail
    session[:redirect_after_failed_login_path] = new_user_session_path
  end
end
