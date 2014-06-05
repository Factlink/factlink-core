class Users::PasswordsController < Devise::PasswordsController
  layout "one_column"

  skip_before_filter :require_no_authentication, only: [:new]
  prepend_before_filter :sign_out_user, except: [:new]

  def new
    self.resource = current_user || super
  end

  def edit
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, params[:reset_password_token])
    user = User.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)

    if user.persisted? and not user.password_token_expired?
      super
    else
      redirect_to new_user_password_path, :alert => 'Password restore link is invalid'
    end
  end

  private

  def sign_out_user
    sign_out if current_user
    true
  end
end
