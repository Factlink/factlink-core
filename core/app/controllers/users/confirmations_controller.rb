class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      # sign_in(resource_name, resource) #Don't sign in, we don't allow that
      respond_with_navigational(resource){ redirect_to "/" } # Redirect to the root
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end