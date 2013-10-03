class Users::SetupController < ApplicationController

  before_filter :setup_step_in_process

  layout "one_column_simple"

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

    saved = interactor(:'accounts/setup', user: current_user, attribuutjes: params[:user])

    if saved
      sign_in current_user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change
      redirect_to '/'
    else
      @user = current_user
      render 'users/setup/edit'
    end
  end

end
