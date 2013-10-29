class Users::SessionsController < Devise::SessionsController

  layout "client"

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out
    mp_track "User: Sign out"
  end

  def track_sign_in
    mp_track_people_event sign_in_count: current_user.sign_in_count
    mp_track "User: Sign in"
  end

  before_filter :redirect_to_homepage, only: :new

  def redirect_to_homepage
    return if params[:layout] == 'client'

    flash.keep
    redirect_to '/?show_sign_in=1'
  end
end
