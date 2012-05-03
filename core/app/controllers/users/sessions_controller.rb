class Users::SessionsController < Devise::SessionsController
  layout :choose_layout
  def choose_layout
    @layout = if params[:layout] == 'popup'
      'popup'
    else
      'frontend'
    end
  end

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out; track "Sign out"; end
  def track_sign_in; track "Sign in"; end

  before_filter :set_redir, only: :create
  def set_redir
    if params[:layout] == 'popup'
      session[:return_to] = new_fact_path(layout: 'popup')
      session[:just_signed_in] = true
    else
      session[:return_to] = nil
      session[:just_signed_in] = nil
    end
  end
end
