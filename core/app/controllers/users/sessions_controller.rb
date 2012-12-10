class Users::SessionsController < Devise::SessionsController

  DEFAULT_LAYOUT = "one_column"

  layout :set_layout

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out; track "Sign out"; end
  def track_sign_in; track "Sign in"; end

  before_filter :set_layout, only: :new

  before_filter :set_redir, only: [:create, :new]

  private
  def set_redir
    if params[:layout] == 'client'
      session[:redirect_after_failed_login_path] = new_user_session_path(layout:"client")
      puts "1 Setting redirect_after_failed_login_path to: #{session[:redirect_after_failed_login_path]}"
      session[:just_signed_in] = true
    else
      session[:redirect_after_failed_login_path] = new_user_session_path
      puts "2 Setting redirect_after_failed_login_path to: #{session[:redirect_after_failed_login_path]}"
      session[:return_to] = nil
      session[:just_signed_in] = nil
    end
  end
end
