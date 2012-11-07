require 'spec_helper'

describe UsersController do
  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :show do
    it "should render a 404 when an invalid username is given" do
      invalid_username = 'henk2!^geert'
      authenticate_user!(user)
      expect do
        get :show, username: invalid_username
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe :activities do
    it "should render succesful" do
      authenticate_user!(user)

      should_check_can :see_activities, user

      get :activities, :username => user.username, :format => :json

      response.should be_success
    end
  end

  describe :mark_as_read do
    it "should update last read timestamp on the user" do
      datetime = DateTime.parse("2001-02-03T04:05:06+01:00")

      authenticate_user!(user)

      should_check_can :mark_activities_as_read, user

      DateTime.stub!(:now).and_return datetime

      post :mark_activities_as_read, :username => user.username, :format => :json

      response.should be_success

      User.find(user.id).last_read_activities_on.to_i.should == datetime.to_i
    end
  end

  describe :update do
    before do
      authenticate_user!(user)

      should_check_can :update, user
    end

    it "should redirect to the correct path after changing a username" do
      put :update, :id => user.username, :user => {'username' => 'nice_username'}

      response.should redirect_to edit_user_path('nice_username')
    end

    it "should not allow people to update their passwords" do
      old_user = User.find(user.id)

      encrypted_password = old_user.encrypted_password
      old_username = old_user.username

      put :update, :id => user.username, :user => {'encrypted_password' => "blaat_password", "username" => "new_username"}

      new_user = User.find(user.id)

      new_user.encrypted_password.should == encrypted_password
      new_user.username.should == "new_username"
    end
  end

end
