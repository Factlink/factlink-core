require 'spec_helper'

describe Api::UsersController do
  include FeedHelper

  let(:user) { create(:user, features: ['some_feature']) }

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

  describe :show do
    it "should render json successful" do
      FactoryGirl.reload

      ability.should_receive(:can?).with(:show, user).and_return(true)

      get :show, username: user.username, format: :json

      verify { response.body }
    end

    it "should render json successful for deleted users" do
      FactoryGirl.reload
      SecureRandom.stub(:hex).and_return('b01dfacedeadbeefbabb1e0123456789')

      deleted_user = create(:user)
      as(deleted_user) do |pavlov|
        pavlov.interactor(:'users/delete', user_id: deleted_user.id, current_user_password: '123hoi')
      end
      deleted_user = User.find deleted_user.id

      ability.should_receive(:can?).with(:show, deleted_user).and_return(true)

      get :show, username: deleted_user.username, format: :json

      verify { response.body }
    end
  end

  describe :update do
    before do
      authenticate_user!(user)

      ability.should_receive(:can?).with(:update, user).and_return(true)
    end

    it "should redirect to the correct path after changing a username" do
      put :update, original_username: user.username, username: 'nice_username'

      User.find('nice_username').should_not be_nil
    end

    it "should not allow people to update their passwords" do
      old_user = User.find(user.id)

      encrypted_password = old_user.encrypted_password

      put :update, original_username: user.username, encrypted_password: "blaat_password", username: "new_username"

      new_user = User.find(user.id)

      expect(new_user.encrypted_password).to eq encrypted_password
      expect(new_user.username).to eq "new_username"
    end
  end

end
