require 'spec_helper'

describe FeedController do
  render_views

  let(:user) { create :user }

  describe "#index" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :access, Ability::FactlinkWebapp
      should_check_can :show, user
      get :index, format: :json, username: user.username

      response.should be_success
      verify(format: :json) { response.body }
    end
  end

end
