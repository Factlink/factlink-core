class TourController < ApplicationController

  before_filter :authenticate_user!
  layout "one_column"

  def almost_done
    @step_in_signup_process = :account
  end

  def create_your_first_factlink
    @step_in_signup_process = :create_factlink
    render layout: "frontend"
  end

  def choose_channels
    @step_in_signup_process = :almost_done
    @user = current_user
    render inline:'', layout: "channels", locals: {not_fixed: true}
  end

end
