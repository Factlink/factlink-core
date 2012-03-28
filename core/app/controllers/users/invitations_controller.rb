class Users::InvitationsController < Devise::InvitationsController
  def after_invite_path_for(resource)
    after_sign_in_path_for(current_user)
  end
end
