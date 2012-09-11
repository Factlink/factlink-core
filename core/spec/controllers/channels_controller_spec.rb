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
    [f1,f2,f3].each { |f| ch1.add_fact f }
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
      authenticate_user!(user)
      should_check_can :index, Channel
      get :index, username: user.username, format: 'json'
      response.should be_success
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
