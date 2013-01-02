require 'spec_helper'

describe SubchannelsController do
  render_views

  let(:user) {create(:user)}
  let(:otheruser) {create(:user)}

  let(:ch1) {create :channel, created_by: user.graph_user}

  let(:followed_channel) {create :channel, created_by: otheruser.graph_user }

  describe "#index" do
    it "as json should be successful" do
      ch1.add_channel followed_channel

      authenticate_user!(user)
      should_check_can :show, ch1
      ability.should_receive(:can?).with(:index, Channel).and_return true
      get :index, username: user.username, channel_id: ch1.id, format: 'json'
      response.should be_success
    end
  end

  describe "#create" do
    it "as json should be successful on own channel" do
      authenticate_user!(user)
      should_check_can :update, ch1
      ability.should_receive(:can?).with(:index, Channel).and_return true
      post :create, username: user.username, channel_id: ch1.id, id: followed_channel.id, format: 'json'
      response.should be_success
    end
  end
end
