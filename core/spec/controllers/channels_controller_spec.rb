require 'spec_helper'

describe ChannelsController do
  include Devise::TestHelpers
  include ControllerMethods
  
  render_views

  let (:user) {FactoryGirl.create(:user)}

  let (:ch1) {FactoryGirl.create(:channel)}
  let (:f1) {FactoryGirl.create(:fact)}
  let (:f2) {FactoryGirl.create(:fact)}
  let (:f3) {FactoryGirl.create(:fact)}

  before do
    ch1.created_by = user.graph_user
    ch1.add_fact f1
    ch1.add_fact f2
    ch1.add_fact f3
    ch1.save
  end

  before do
    get_ability
  end
  
  describe "#new" do
    it "should be succesful" do
      authenticate_user!(user)
      should_check_can :new, Channel
      get :new, username: user.username
      response.should be_succes
    end
  end

  describe "#index" do
    it "as json should be successful" do
      authenticate_user!(user)
      should_check_can :index, Channel
      get :index, username: user.username, format: 'json'
      response.should be_succes
    end
  end
  
  describe "#related_users" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :related_users, username: user.username, id: ch1.id
      response.should be_succes
    end
  end

  describe "#activities" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :activities, username: user.username, id: ch1.id
      response.should be_succes
    end
  end
  
  describe "#get_facts_for" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :facts, username: user.username, id: ch1.id
      response.should be_succes
    end
  end
  

  describe "#show" do
    it "a channel should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :show, username: user.username, id: ch1.id
      response.should be_succes
    end

    it "a channel as json should be succesful" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :show, username: user.username, id: ch1.id, format: 'json'
      response.should be_succes
    end
  end

  
end
