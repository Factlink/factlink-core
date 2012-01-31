class Users::SessionsController < Devise::SessionsController
  layout "frontend"

  after_filter :track_sign_in, :only => [:create]
  before_filter :track_sign_out, :only => [:destroy]

  def track_sign_in
    @mixpanel.track_event("Sign in", mixpanel_user_identity_opts)
  end

  def track_sign_out
    @mixpanel.track_event("Sign out", mixpanel_user_identity_opts)
  end

  def mixpanel_user_identity_opts
    { :mp_name_tag => current_user.username,
      :distinct_id => current_user.id } if current_user
  end
end
