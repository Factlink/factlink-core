class Users::PasswordsController < Devise::PasswordsController

  layout "one_column_simple"

  def edit
    # Copied from Devise::PasswordsController
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    # end of copy

    @user = User.where(reset_password_token: params[:reset_password_token]).first

    if params[:msg]
      sign_in @user
      redirect_to after_sign_in_path_for(@user)
    else
      render :edit
    end
  end

end
