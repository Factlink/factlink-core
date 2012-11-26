require 'spec_helper'

describe SubchannelsController do
  render_views


  let (:user) {FactoryGirl.create(:user)}
  let (:otheruser) {FactoryGirl.create(:user)}

  let (:ch1) {FactoryGirl.create(:channel)}
  let (:subch1) {FactoryGirl.create(:channel)}
  let (:subch2) {FactoryGirl.create(:channel)}
  let (:subch3) {FactoryGirl.create(:channel)}

  let (:otherch1) {FactoryGirl.create(:channel)}
  let (:othersubch1) {FactoryGirl.create(:channel)}
  let (:othersubch2) {FactoryGirl.create(:channel)}
  let (:othersubch3) {FactoryGirl.create(:channel)}

  before do
    [ch1,subch1,subch2,subch3].each do |ch|
      ch.created_by = user.graph_user
      ch.save
    end
    [otherch1,othersubch1,othersubch2,othersubch3].each do |ch|
      ch.created_by = otheruser.graph_user
      ch.save
    end
  end
  
  describe "#index" do
    it "as json should be successful" do
      authenticate_user!(user)
      get :index, username: user.username, channel_id: ch1.id, format: 'json'
      response.should be_success
    end
  end

  describe "#create" do
    it "as json should be successful on own channel" do
      authenticate_user!(user)
      should_check_can :update, ch1
      post :create, username: user.username, channel_id: ch1.id, id: subch1.id, format: 'json'
      response.should be_success
    end
  end
end
