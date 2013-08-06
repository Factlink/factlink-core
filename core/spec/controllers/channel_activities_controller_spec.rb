require 'spec_helper'

describe ChannelActivitiesController do
  render_views

  before { Resque.stub(:enqueue) }

  let (:user) {create(:user)}

  let (:f1) {create(:fact)}
  let (:f2) {create(:fact)}
  let (:f3) {create(:fact)}

  let (:ch1) do
    ch1 = create :channel, created_by: user.graph_user
    [f1,f2,f3].each do |f|
      Interactors::Channels::AddFact.new(fact: f, channel: ch1,
        pavlov_options: { no_current_user: true }).call
    end
    ch1
  end

  describe "#index" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :access, Ability::FactlinkWebapp
      should_check_can :show, ch1
      get :index, username: user.username, channel_id: ch1.id
      response.should be_success
    end
  end

end
