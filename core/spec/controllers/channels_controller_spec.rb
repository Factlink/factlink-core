require 'spec_helper'

describe ChannelsController do
  render_views

  let (:user) { create :user }

  let (:f1) {create :fact, created_by: user.graph_user}
  let (:f2) {create :fact, created_by: user.graph_user}
  let (:f3) {create :fact, created_by: user.graph_user}

  let (:ch_heavy) do
    ch_heavy = create :channel, created_by: user.graph_user
    [f1,f2,f3].each do |f|
      Interactors::Channels::AddFact.new(fact: f, channel: ch_heavy, pavlov_options: { current_user: user }).call
    end
    ch_heavy
  end

  let(:ch_light) { create :channel, created_by: user.graph_user }

  describe "#index" do
    it "as json should be successful" do
      ch_light
      authenticate_user!(user)
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success
    end

    it "should render the same json as previously (regression check)" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check
      ch_heavy
      authenticate_user!(user)
      ability.should_receive(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success

      response_body = response.body.to_s
      # strip created_by mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'channels.json should keep the same content')
    end
  end

  describe "#show" do
    it "a channel should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch_light
      get :show, username: user.username, id: ch_light.id
      response.should be_success
    end

    it "a channel as json should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch_heavy

      ability.should_receive(:can?).with(:index, Channel).and_return true
      get :show, username: user.username, id: ch_heavy.id, format: 'json'
      response.should be_success
    end

    it "should escape html in fields" do
      authenticate_user!(user)
      ch = create(:channel)
      ch.title = "baas<xss> of niet"
      ch.created_by = user.graph_user
      ch.save

      should_check_can :show, ch
      get :show, :id => ch.id, :username => user.username

      response.body.should_not match(/<xss>/)
    end
  end
end
