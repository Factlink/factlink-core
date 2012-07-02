require 'spec_helper'

describe TourController do

  let(:user) { FactoryGirl.create :user, agrees_tos: false }

	describe :almost_done do
    it "should render almost_done template" do
      authenticate_user!(user)
      get :almost_done
      response.should render_template(template: /\Atour\/almost_done\Z/, layout: "layouts/frontend")
      assigns(:step_in_signup_process).should eq(:almost_done)
    end
  end

end
