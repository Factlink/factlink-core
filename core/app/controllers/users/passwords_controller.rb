class Users::PasswordsController < Devise::PasswordsController

  before_filter :setup_step_in_process, only: [:edit, :update]

  def setup_step_in_process
    @step_in_signup_process = :account if params[:msg] == 'welcome'
  end

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]

    @user = User.where(reset_password_token: params[:reset_password_token]).first

    if params[:msg] and not @user
      redirect_to new_user_session_path, notice: 'Your account is already set up. Please log in to continue.'
    else
      render
    end
  end

end
