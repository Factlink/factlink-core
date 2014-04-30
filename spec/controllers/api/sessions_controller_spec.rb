require 'spec_helper'

describe Api::SessionsController do
  include FeedHelper

  let(:user) do
    create(:user).tap do |user|
      user.features << Feature.create!(name: 'some_feature')
      Backend::Groups.create(groupname: 'abc', usernames: [ user.username] )
    end
  end

  describe :current do
    it "should render json successful for current user" do
      FactoryGirl.reload
      user.save!

      authenticate_user!(user)

      get :current, format: :json

      verify { response.body }
    end

    it "should render json successful for non signed in user" do
      FactoryGirl.reload

      as(create :user, :confirmed, :admin) do |pavlov|
        pavlov.interactor(:'global_features/set', features: [:some_global_feature])
      end

      get :current, format: :json

      verify { response.body }
    end
  end
end
