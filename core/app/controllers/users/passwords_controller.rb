class Users::PasswordsController < Devise::PasswordsController

  before_filter :setup_step_in_process, only: [:edit, :update]

  def setup_step_in_process
    @step_in_signup_process = :account if params[:msg] == 'welcome'
  end

  def edit
    # Copied from Devise::PasswordsController
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    # end of copy

    @user = User.where(reset_password_token: params[:reset_password_token]).first

    if params[:msg] and not @user
      redirect_to new_user_session_path, notice: 'Your account is already set up. Please log in to continue.'
    else
      render
    end
  end

  def update
    # Copied from Devise::PasswordsController
    self.resource = resource_class.reset_password_by_token(resource_params)
    # end of copy

    if params[:msg]
      resource.set_names(params[:user][:first_name].to_s, params[:user][:last_name].to_s)
    end

    # Copied from Devise::PasswordsController
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource
    end
    # end of copy
  end

end
