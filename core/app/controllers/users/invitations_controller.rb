class Users::InvitationsController < Devise::InvitationsController
  def create
    self.resource = resource_class.invite! params[resource_name], current_inviter do |invitee|
      invitee.instance_variable_set :@invitation_message, params[:invite][:message]
      class << invitee
        def invitation_message
          @invitation_message
        end
      end
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  def after_invite_path_for(resource)
    after_sign_in_path_for(current_user)
  end
end
