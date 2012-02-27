require 'spec_helper'

describe UsersController do
  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :activities do
    it "should render succesful" do
      authenticate_user!(user)

      should_check_can :index, Activity

      get :activities, :username => user.username, :format => :json

      response.should be_success
    end
  end

  describe :mark_as_read do
    it "should update last read timestamp on the user" do
      pending "reenabling this functionality"
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
    it "should redirect to the correct path after changing a username" do
      authenticate_user!(user)

      should_check_can :update, user

      put :update, :id => user.username, :user => {'username' => 'nice_username'}

      response.should redirect_to edit_user_path('nice_username')
    end
  end

end