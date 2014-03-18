require 'spec_helper'

describe Api::FeedController do
  include FeedHelper

  render_views

  let(:user) { create :user }

  describe "#personal" do
    it "should render" do
      FactoryGirl.reload
      create_default_activities_for user

      authenticate_user!(user)
      get :personal, format: :json, username: user.username

      response.should be_success
      verify { response.body }
    end
  end

  describe "#global" do
    include PavlovSupport

    it "should render" do
      FactoryGirl.reload
      create_default_activities_for user

      get :global, format: :json

      response.should be_success
      verify { response.body }
    end
  end
end
