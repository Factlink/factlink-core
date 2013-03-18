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

    agrees_tos = (params[:user][:agrees_tos].to_i == 1) ? true : false

    if current_user.sign_tos(agrees_tos)
      track_signed_tos
      track_tos_browser
      redirect_to start_the_tour_path
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
