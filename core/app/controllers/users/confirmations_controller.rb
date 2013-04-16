class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "waiting_list"

  before_filter :require_no_authentication, :only => :show
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?

      unless resource.approved?
        respond_with_navigational(resource){ render "awaiting_approval" }
      else
        redirect_to "/"
      end
    else
      if params[:confirmation_token]
        @params_token = true
      end
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
