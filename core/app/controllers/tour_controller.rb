class TourController < ApplicationController

	before_filter :authenticate_user!
	layout "one_column"

	def almost_done
		@step_in_signup_process = :almost_done
	end

  def choose_channels
    @step_in_signup_process = :almost_done
    @user = current_user
    render inline:'', layout: "channels"
  end

end