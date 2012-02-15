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
      datetime = DateTime.parse("2001-02-03T04:05:06+07:00").change(:offset => "+0000")

      authenticate_user!(user)

      should_check_can :mark_activities_as_read, user

      DateTime.stub!(:now).and_return datetime

      post :mark_activities_as_read, :username => user.username, :format => :json

      response.should be_success

      User.find(user.id).last_read_activities_on.to_i.should == datetime.to_i
    end
  end

end