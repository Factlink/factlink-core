class TourController < ApplicationController
  before_filter :common_tour

  # first step is account, and this is in other controllers
  # search for @step_in_signup_process = :account

  def create_your_first_factlink
    render layout: "one_column"
  end

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

    set_seen_tour_step
  end

  def set_seen_tour_step
    return if seen_the_tour(current_user)

    current_user.seen_tour_step = action_name
    current_user.save!

    track_people_event tour_completed: true if seen_the_tour(current_user)
  rescue
    Raven.capture_exception(exception)
  end

end
