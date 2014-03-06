require 'spec_helper'

describe Api::UsersController do
  include FeedHelper

  render_views

  let(:user) { create :user }

  describe "#feed" do
    include PavlovSupport

    it "should render" do
      FactoryGirl.reload
      create_default_activities_for user

      authenticate_user!(user)
      get :feed, format: :json, username: user.username

      response.should be_success
      verify { response.body }
    end
  end

end
