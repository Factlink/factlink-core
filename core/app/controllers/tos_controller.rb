class TosController < ApplicationController

  before_filter :authenticate_user!, only: [:update]
  layout "frontend"

  def show
    if can? :sign_tos, current_user
      @step_in_signup_process = :account
    end
  end

  def update
    authorize! :sign_tos, current_user

    agrees_tos      = (params[:user][:agrees_tos].to_i == 1) ? true : false

    first_name = params[:user][:tos_first_name]
    last_name  = params[:user][:tos_last_name]

    if current_user.sign_tos(agrees_tos, first_name, last_name)
      track_signed_tos
      track_tos_browser
      redirect_to almost_done_path
    else
      render :show
    end
  end

  private
  def track_signed_tos
    track_people_event signed_tos: true
  end
  def track_tos_browser
    tos_browser_name    = params[:tos_browser_name]
    tos_browser_version = params[:tos_browser_version]
    track_people_event tos_browser_name: tos_browser_name, tos_browser_version: tos_browser_version
  end

end
