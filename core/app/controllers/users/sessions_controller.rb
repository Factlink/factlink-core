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
end
