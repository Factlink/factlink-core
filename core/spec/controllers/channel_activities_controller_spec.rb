require 'spec_helper'

describe ChannelActivitiesController do
  render_views

  before { Resque.stub!(:enqueue,nil) }

  let (:user) {FactoryGirl.create(:user)}

  let (:f1) {create(:fact)}
  let (:f2) {create(:fact)}
  let (:f3) {create(:fact)}

  let (:ch1) do
    ch1 = create :channel, created_by: user.graph_user
    [f1,f2,f3].each do |f|
      Interactors::Channels::AddFact.new(f, ch1, no_current_user: true).execute
    end
    ch1
  end

  describe "#index" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :index, username: user.username, channel_id: ch1.id
      response.should be_success
    end
  end

end
