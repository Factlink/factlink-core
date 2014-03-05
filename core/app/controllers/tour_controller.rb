class TourController < ApplicationController
  before_filter :common_tour

  def install_extension
    render layout: "tour"
  end

  def interests
    render text: "", layout: "tour"
  end

  def tour_done
    redirect_to after_sign_in_path_for(current_user)
  end

  private

  def common_tour
    authenticate_user!
    authorize! :access, Ability::FactlinkWebapp

    @step_in_signup_process = action_name.to_sym
  end
end
