require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }

  describe :show do
    render_views
    it "should render a 404 when an invalid username is given" do
      invalid_username = 'henk2!^geert'
      authenticate_user!(user)
      expect do
        get :show, username: invalid_username
      end.to raise_error(ActionController::RoutingError)
    end

    it "should render json successful" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      should_check_can :show, user
      get :show, username: user.username, format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'users#show should keep the same content')
    end
  end

  describe :tour_users do
    render_views
    include PavlovSupport

    it "should render json successful" do
      FactoryGirl.reload # hack because of fixture in check

      user1 = create :user
      user2 = create :user
      Pavlov.old_command :"users/add_handpicked_user", user1.id.to_s
      Pavlov.old_command :"users/add_handpicked_user", user2.id.to_s

      as(user1) do |pavlov|
        ch1 = pavlov.old_command :'channels/create', 'toy'
        pavlov.old_command :'topics/update_user_authority', user1.graph_user_id.to_s, ch1.slug_title, 0

        ch2 = pavlov.old_command :'channels/create', 'story'
        pavlov.old_command :'topics/update_user_authority', user1.graph_user_id.to_s, ch2.slug_title, 3
      end
      as(user2) do |pavlov|
        ch1 = pavlov.old_command :'channels/create', 'war'
        pavlov.old_command :'topics/update_user_authority', user2.graph_user_id.to_s, ch1.slug_title, 0

        ch2 = pavlov.old_command :'channels/create', 'games'
        pavlov.old_command :'topics/update_user_authority', user2.graph_user_id.to_s, ch2.slug_title, 4568
      end

      authenticate_user!(user)
      ability.stub(:can?).with(:access, Ability::FactlinkWebapp)
             .and_return(true)
      ability.stub(:can?).with(:index, User)
             .and_return(true)

      get :tour_users, format: :json
      response.should be_success
      response_body = response.body.to_s

      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      response_body = JSON.parse(response_body).sort do |a,b|
        a["username"] <=> b["username"]
      end.to_json
      Approvals.verify(response_body, format: :json, name: 'users#tour_users should keep the same content')
    end
  end

  describe :activities do
    render_views
    it "should render succesful" do
      authenticate_user!(user)

      should_check_can :see_activities, user

      get :activities, username: user.username, format: :json

      response.should be_success
    end
  end

  describe :mark_as_read do
    render_views
    it "should update last read timestamp on the user" do
      datetime = DateTime.parse("2001-02-03T04:05:06+01:00")

      authenticate_user!(user)

      should_check_can :mark_activities_as_read, user

      DateTime.stub!(:now).and_return datetime

      post :mark_activities_as_read, username: user.username, format: :json

      response.should be_success

      User.find(user.id).last_read_activities_on.to_i.should == datetime.to_i
    end
  end

  describe :update do
    render_views
    before do
      authenticate_user!(user)

      should_check_can :update, user
    end

    it "should redirect to the correct path after changing a username" do
      put :update, id: user.username, user: {'username' => 'nice_username'}

      response.should redirect_to edit_user_path('nice_username')
    end

    it "should not allow people to update their passwords" do
      old_user = User.find(user.id)

      encrypted_password = old_user.encrypted_password
      old_username = old_user.username

      put :update, id: user.username, user: {'encrypted_password' => "blaat_password", "username" => "new_username"}

      new_user = User.find(user.id)

      new_user.encrypted_password.should == encrypted_password
      new_user.username.should == "new_username"
    end
  end
end
