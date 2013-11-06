class Users::EditPasswordController < ApplicationController
  layout "frontend"

  before_filter :load_user
  before_filter :authenticate_user!

  def edit_password
    authorize! :update, @user

    render "users/edit_password"
  end

  def update_password
    authorize! :update, @user

    if @user.update_with_password(params[:user])
      sign_in @user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change
      redirect_to user_password_edit_url(@user), notice: 'Your password was successfully updated.'
    else
      render "users/edit_password"
    end
  end

  private

  def load_user
    @user = ::User.find_by(:username => params[:user_id]) or raise_404
  end
end
