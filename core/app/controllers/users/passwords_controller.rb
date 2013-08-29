class Users::PasswordsController < Devise::PasswordsController

  before_filter :setup_step_in_process, only: [:edit, :update]

  layout "one_column_simple"

  def setup_step_in_process
    @step_in_signup_process = :account if params[:msg] == 'welcome'
  end

  def edit
    # Copied from Devise::PasswordsController
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    # end of copy

    @user = User.where(reset_password_token: params[:reset_password_token]).first

    if params[:msg]
      if @user
        mp_track "Tour: Started account setup", current_user: @user
        render :setup_account
      else
        redirect_to new_user_session_path,
          notice: 'Your account is already set up. Please log in to continue.'
      end
    else
      render :edit
    end
  end

  def update
    if params[:msg]
      update_setup_account
    else
      super
    end
  end

  def update_setup_account
    self.resource = interactor(:'accounts/setup_approved', reset_password_token: resource_params[:reset_password_token], attribuutjes: resource_params)

    if resource.errors.empty?
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      respond_with resource, template: 'users/passwords/setup_account'
    end
  end

end
