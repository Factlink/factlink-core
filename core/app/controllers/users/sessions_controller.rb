class Users::SessionsController < Devise::SessionsController
  layout "frontend"

  after_filter  :track_sign_in, only: :create 
  before_filter :track_sign_in, only: :destroy

  def track_sign_out; track "Sign out"; end
  def track_sign_in; track "Sign in"; end
end
