class Users::SetupController < ApplicationController

  before_filter :setup_step_in_process

  layout "one_column"

  def setup_step_in_process
    @step_in_signup_process = :account
  end

  def edit
    authorize! :set_up, current_user

    @user = current_user
    mp_track "Tour: Started account setup", current_user: current_user
  end

  def update
    authorize! :set_up, current_user

    @user = current_user
    @user.set_up = true
    @user.reset_password!(params[:user][:password].to_s, params[:user][:password_confirmation].to_s) # this saves the user

    if @user.changed?
      render 'users/setup/edit'
    else
      sign_in @user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change
      redirect_to '/'
    end
  end

end
