class TosController < ApplicationController

  before_filter :authenticate_user!, only: [:update]
  layout "frontend"

  def show
  end

  def update
    authorize! :sign_tos, current_user

    agrees_tos      = (params[:user][:agrees_tos].to_i == 1) ? true : false
    agrees_tos_name = params[:user][:agrees_tos_name]

    if current_user.sign_tos(agrees_tos, agrees_tos_name)
      redirect_to user_profile_path(current_user)
    else
      render :show
    end
  end

end
