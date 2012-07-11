class TourController < ApplicationController

	before_filter :authenticate_user!
	layout "one_column"

	def almost_done
		@step_in_signup_process = :account
	end

end