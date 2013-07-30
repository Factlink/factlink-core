require 'spec_helper'

describe TourController do

  let(:user) { create :user }

  describe :install_extension do
    it "should render install_extension template" do
      authenticate_user!(user)
      get :install_extension
      response.should render_template(template: /\Atour\/install_extension\Z/, layout: "layouts/tour")
      assigns(:step_in_signup_process).should eq(:install_extension)
    end
  end

end
