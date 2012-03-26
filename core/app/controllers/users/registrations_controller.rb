class Users::RegistrationsController < Devise::RegistrationsController
  layout "frontend"

  before_filter :load_user, only: [:edit_password, :update_password]
  before_filter :authenticate_user!

  def edit_password
    authorize! :update, @user

    render "users/edit_password"
  end

  def update_password
    authorize! :update, @user

    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to user_password_edit_url(@user), notice: 'Your password was successfully updated.'
    else
      render "users/edit_password"
    end
  end

  private
  def load_user
    @user = ::User.first(:conditions => { :username => params[:user_id] }) or raise_404
  end
end