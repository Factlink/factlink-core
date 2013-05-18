class Users::InvitationsController < Devise::InvitationsController
  layout "frontend"

  def new
    @resource = nil.andand
    super
  end

  def create
    self.resource = resource_class.invite! params[resource_name], current_inviter do |invitee|
      invitee.save
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      @resource = nil.andand
      respond_with_navigational(resource) { render :new }
    end
  end

  def after_invite_path_for(resource)
    if current_user.has_invitations_left?
      new_user_invitation_path
    else
      after_sign_in_path_for(current_user)
    end
  end

  before_filter :setup_step_in_process, only: [:edit, :update]
  def setup_step_in_process
    @step_in_signup_process = :account
  end
end
