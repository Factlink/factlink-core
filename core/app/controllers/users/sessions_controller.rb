class Users::SessionsController < Devise::SessionsController
  before_filter :track_sign_out, only: :destroy

  def track_sign_out
    mp_track "User: Sign out"
  end

  def new
    flash.keep
    redirect_to root_path
  end

  def create
    fail 'Old sign in page -- should never be reached'
  end
end
