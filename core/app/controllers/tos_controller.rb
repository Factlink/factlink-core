class TosController < ApplicationController

  before_filter :authenticate_user!
  layout "frontend"

  def show
    authorize! :read_tos, current_user
  end

  def update
    authorize! :sign_tos, current_user

    agrees_tos  = (params[:user][:agrees_tos].to_i == 1) ? true : false
    name        = params[:user][:name]

    if current_user.sign_tos(agrees_tos,name)
      redirect_to user_profile_path(current_user)
    else
      render :show
    end
  end

end
