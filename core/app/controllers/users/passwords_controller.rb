class Users::PasswordsController < Devise::PasswordsController

  before_filter :setup_step_in_process, only: [:edit, :update]

  def setup_step_in_process
    @step_in_signup_process = :account if params[:msg] == 'welcome'
  end

end