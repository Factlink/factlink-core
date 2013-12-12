class TourController < ApplicationController
  before_filter :common_tour

  # first step is account, and this is in other controllers
  # search for @step_in_signup_process = :account

  def create_your_first_factlink
    render layout: "tour"
    mp_track "Tour: Loaded create your first Factlink"
  end

  def install_extension
    render layout: "tour"
    mp_track "Tour: Loaded install extension"
  end

  def interests
    render text: "", layout: "tour"
    mp_track "Tour: Loaded interesting users"
  end

  def tour_done
    redirect_to after_sign_in_path_for(current_user)
    mp_track "Tour: Finished"
    mp_track_people_event tour_completed: true
  end

  private

  def common_tour
    authenticate_user!
    authorize! :access, Ability::FactlinkWebapp

    @step_in_signup_process = action_name.to_sym

    track_extension_action
    set_seen_tour_step
  end

  def set_seen_tour_step
    return if seen_the_tour(current_user)

    current_user.seen_tour_step = action_name
    current_user.save!
  end

  def track_extension_action
    if ['chrome_extension_skip', 'firefox_extension_skip',
        'chrome_extension_next', 'firefox_extension_next'].include?(params[:ref])
      mp_track "#{params[:ref]} click".capitalize
    end
  end
end
