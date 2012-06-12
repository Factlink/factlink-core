class TosController < ApplicationController

  before_filter :authenticate_user!, only: [:update]
  layout "frontend"

  def show
    if can? :sign_tos, current_user
      @step_in_signup_process = :sign_tos
    end
  end

  def update
    authorize! :sign_tos, current_user

    agrees_tos      = (params[:user][:agrees_tos].to_i == 1) ? true : false
    agrees_tos_name = params[:user][:agrees_tos_name]

    if current_user.sign_tos(agrees_tos, agrees_tos_name)
      redirect_to after_sign_in_path_for(current_user)
    else
      render :show
    end
  end

end
