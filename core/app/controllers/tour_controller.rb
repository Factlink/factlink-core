class TourController < ApplicationController

  before_filter :authenticate_user!
  layout "tour"

  before_filter :can_access_webapp

  def almost_done
    @step_in_signup_process = :account
  end

  def create_your_first_factlink
    @step_in_signup_process = :create_factlink
    render layout: "one_column"
  end

  def choose_channels
    @step_in_signup_process = :almost_done
    @user = current_user
    set_seen_the_tour current_user
    render inline:'', layout: "channels", locals: { wide: true }
  end

  private
  def set_seen_the_tour user
    user.seen_the_tour = true
    user.save!

    track_people_event tour_completed: true
  rescue
    Raven.capture_exception(exception)
  end

  def can_access_webapp
    authorize! :access, Ability::FactlinkWebapp
  end
end
