require 'spec_helper'

describe FrontendController do
  let(:user) { create(:user) }

  describe :user_profile do
    render_views
    it "should render a 404 when an invalid username is given" do
      invalid_username = 'henk2!^geert'
      authenticate_user!(user)
      expect do
        get :user_profile, username: invalid_username
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
