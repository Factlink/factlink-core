class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user

  # TODO: convert this page to backbone
  def edit
    authorize! :update, @user
  end

  def update
    authorize! :update, @user

    if @user.update_attributes params[:user]
      redirect_to edit_user_url(@user.username), notice: 'Your account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @user

    interactor(:'users/delete', user_id: @user.id,
                                current_user_password: params[:user][:password]) do |delete|

      if delete.valid?
        delete.call
        sign_out
        redirect_to root_path, notice: 'Your account has been deleted.'
      else
        redirect_to edit_user_path(current_user), alert: 'Your account could not be deleted. Did you enter the correct password?'
      end
    end
  end

  def notification_settings
    authorize! :edit_settings, @user

    backbone_responder
  end

  private

  def load_user
    username = params[:username] || params[:id]
    @user = Backend::Users.user_by_username(username: username)
    @user or raise_404
  end
end
