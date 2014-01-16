require 'spec_helper'

describe UsersController do
  include PavlovSupport
  let(:user) { create(:full_user) }

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
      FactoryGirl.reload

      should_check_can :show, user

      get :show, username: user.username, format: :json

      Approvals.verify(response.body, format: :json, name: 'users#show should keep the same content')
    end

    it "should render json successful for deleted users" do
      FactoryGirl.reload
      SecureRandom.stub(:hex).and_return('b01dfacedeadbeefbabb1e0123456789')

      deleted_user = create(:full_user)
      as(deleted_user) do |pavlov|
        pavlov.interactor(:'users/delete', user_id: deleted_user.id, current_user_password: '123hoi')
      end
      deleted_user = User.find deleted_user.id

      should_check_can :show, deleted_user

      get :show, username: deleted_user.username, format: :json

      Approvals.verify(response.body, format: :json, name: 'users#show should keep the same content for deleted users')
    end
  end

  describe :tour_users do
    render_views
    include PavlovSupport

    it "should render json successful" do
      FactoryGirl.reload

      user1 = create :user
      user2 = create :user
      Pavlov.command(:'users/add_handpicked_user', user_id: user1.id.to_s)
      Pavlov.command(:'users/add_handpicked_user', user_id: user2.id.to_s)

      as(user1) do |pavlov|
        ch1 = pavlov.command(:'channels/create', title: 'toy')
        ch2 = pavlov.command(:'channels/create', title: 'story')
      end
      as(user2) do |pavlov|
        ch1 = pavlov.command(:'channels/create', title: 'war')
        ch2 = pavlov.command(:'channels/create', title: 'games')
      end

      authenticate_user!(user)
      ability.stub(:can?).with(:access, Ability::FactlinkWebapp)
             .and_return(true)
      ability.stub(:can?).with(:index, User)
             .and_return(true)

      get :tour_users, format: :json
      response.should be_success
      response_body = response.body.to_s

      # remove randomness from sorting
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

  describe :activities do
    render_views
    include PavlovSupport

    def backend_create_viewable_channel_for user
      channel = create :channel, {created_by: user.graph_user}
      fact = create :fact, created_by: user.graph_user
      Pavlov.interactor :'channels/add_fact', fact: fact, channel: channel,
                                              pavlov_options: { current_user: user }
      channel
    end

    describe :activity_approval do
      before do
        # Don't send a mail for these activity tests
        stub_const 'Interactors::SendMailForActivity', Class.new
        Interactors::SendMailForActivity.stub(new: double(call: nil),
                                              attribute_set: [double(name:'pavlov_options'),double(name: 'activity')])

        FactoryGirl.reload
      end

      it 'created comment' do
        current_user = create(:full_user)
        fact = create(:fact)
        fact.add_opinion(:believes, current_user.graph_user)

        interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
                                                       type: 'believes', content: 'tex message',
                                                       pavlov_options: { current_user: user })
        comment = interactor.call

        authenticate_user!(current_user)

        should_check_can :see_activities, current_user

        get :activities, username: current_user.username, format: :json

        Approvals.verify(response.body, format: :json, name: "users#activities should keep the same created comment activity")
      end

      it 'created sub comment' do
        current_user = create(:full_user)
        fact = create :fact, created_by: current_user.graph_user

        comment = {}
        as(current_user) do |pavlov|
          comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
        end

        as(user) do |pavlov|
          sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
        end

        authenticate_user!(current_user)

        should_check_can :see_activities, current_user

        get :activities, username: current_user.username, format: :json

        Approvals.verify(response.body, format: :json, name: "users#activities should keep the same created sub comment activity")
      end
    end
  end

  describe :mark_as_read do
    render_views
    it "should update last read timestamp on the user" do
      datetime = DateTime.parse("2001-02-03T04:05:06+01:00")

      authenticate_user!(user)

      should_check_can :mark_activities_as_read, user

      DateTime.stub(:now).and_return datetime

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
