class TosController < ApplicationController
  layout "frontend"

  def show
    @step_in_signup_process = :account
  end
end
