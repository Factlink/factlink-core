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
      authenticate_user!(user)
      ability.stub(:can?).with(:index, Channel).and_return(true)
      get :index, username: user.username, format: 'json'
      response.should be_success
    end

    it "should render the same json as previously (regression check)" do
      FactoryGirl.reload
      ch_heavy
      authenticate_user!(user)
      ability.stub(:can?).with(:index, Channel).and_return(true)

      get :index, username: user.username, format: 'json'

      Approvals.verify(response.body, format: :json, name: 'channels.json should keep the same content')
    end
  end
end
