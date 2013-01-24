require 'spec_helper'

describe ChannelsController do
  render_views

  let (:user) { create :user }
  let (:nonnda_user) { create :user, agrees_tos: false }

  let (:f1) {create :fact}
  let (:f2) {create :fact}
  let (:f3) {create :fact}

  let (:ch1) do
    ch1 = create :channel, created_by: user.graph_user
    [f1,f2,f3].each do |f|
      Interactors::Channels::AddFact.new(f, ch1, no_current_user: true).call
    end
    ch1
  end

  describe "#new" do
    it "should be succesful" do
      authenticate_user!(user)
      should_check_can :new, Channel
      get :new, username: user.username
      response.should be_success
    end
  end

  describe "#index" do
    it "as json should be successful" do
      ch1
      authenticate_user!(user)
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success
    end

    it "should render the same json as previously (regression check)" do
      FactoryGirl.reload # hack because of fixture in check
      ch1
      authenticate_user!(user)
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success

      expected = ActiveSupport::JSON.decode('[{"link":"/johndoe1/channels/3","edit_link":"/johndoe1/channels/3/edit","created_by_authority":"1.0","add_channel_url":"/johndoe1/channels/new","has_authority?":true,"title":"Title 1","long_title":"Title 1","type":"channel","is_created":false,"is_all":false,"is_normal":true,"is_mine":true,"discover_stream?":false,"created_by":{"id":"50a0ccb934257b6509000001","username":"johndoe1","avatar":"\\u003Cimg alt=\\"johndoe1\\" src=\\"https://secure.gravatar.com/avatar/bdcf52014be3eaaf4c83248bc7229900?rating=PG\\u0026amp;size=32\\u0026amp;default=retro\\" title=\\"johndoe1\\" width=\\"32\\" /\\u003E","all_channel_id":"1"},"new_facts":false,"id":"3","slug_title":"title-1","containing_channel_ids":[],"created_by_id":"1","editable?":true,"followable?":false,"inspectable?":true,"unread_count":0}]')
      got = ActiveSupport::JSON.decode(response.body)

      expected.each_with_index do |expected_channel, i|
        expected_channel["created_by"]["id"] = "50a0ccb934257b6509000001"
        got[i]["created_by"]["id"] = "50a0ccb934257b6509000001"
      end

      got[0].should == expected[0]
    end

    it "as bogus user should redirect to Terms of Service page" do
      authenticate_user!(nonnda_user)
      get :index, username: user.username
      response.should redirect_to(tos_path)
    end
  end

  describe "#facts" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :facts, username: user.username, id: ch1.id, :format => :json
      response.should be_success
    end
  end

  describe "#show" do
    it "a channel should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :show, username: user.username, id: ch1.id
      response.should be_success
    end

    it "a channel as json should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch1
      ability.should_receive(:can?).with(:index, Channel).and_return true
      get :show, username: user.username, id: ch1.id, format: 'json'
      response.should be_success
    end

    it "should escape html in fields" do
      authenticate_user!(user)
      @ch = FactoryGirl.create(:channel)
      @ch.title = "baas<xss> of niet"
      @ch.created_by = user.graph_user
      @ch.save

      should_check_can :show, @ch
      get :show, :id => @ch.id, :username => user.username

      response.body.should_not match(/<xss>/)
    end
  end
end
