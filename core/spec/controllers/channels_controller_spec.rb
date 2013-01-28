require 'spec_helper'

describe ChannelsController do
  render_views

  before { Resque.stub!(:enqueue,nil) }

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
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check
      ch1
      authenticate_user!(user)
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success

      response_body = response.body.to_s
      # strip created_by mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'channels.json should keep the same content')
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
