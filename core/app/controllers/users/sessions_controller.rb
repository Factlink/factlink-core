class Users::SessionsController < Devise::SessionsController

  DEFAULT_LAYOUT = "user_session"

  layout :set_layout

  after_filter  :track_sign_in, only: :create
  before_filter :track_sign_out, only: :destroy

  def track_sign_out
    track "User: Sign out"
  end

  def track_sign_in
    track_people_event sign_in_count: current_user.sign_in_count
    track "User: Sign in"
  end

  before_filter :set_layout, only: :new
end
