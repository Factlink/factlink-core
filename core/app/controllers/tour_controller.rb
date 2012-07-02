class TourController < ApplicationController

	before_filter :authenticate_user!
	layout "general"

	def almost_done
		@step_in_signup_process = :almost_done
	end

end