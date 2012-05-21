class Users::PasswordsController < Devise::PasswordsController
  #params[:msg] ? "Set up your Factlink account" : "Change your password" %>
  before_filter :setup_step_in_process, only: [:edit, :update]
  def setup_step_in_process
    @step_in_signup_process = :choose_password if params[:msg] == 'welcome'
  end

end