class Users::PasswordsController < Devise::PasswordsController

  layout "one_column_simple"

  def edit
    if params[:msg] # Warning! Also used for logging in unconfirmed users who request new password
      @user = User.where(reset_password_token: params[:reset_password_token].to_s).first

      if @user
        @user.skip_confirmation!
        @user.save(validate: false)

        sign_in @user, bypass: true
        redirect_to after_sign_in_path_for(@user).to_s
      else
        redirect_to new_user_session_path,
          notice: 'Your account is already set up. Please log in to continue.'
      end
    else
      super
    end
  end

end
