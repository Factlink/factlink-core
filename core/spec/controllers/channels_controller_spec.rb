require 'spec_helper'

describe ChannelsController do
  include Devise::TestHelpers
  include ControllerMethods
  
  render_views

  let (:user) {FactoryGirl.create(:user)}
  let (:bogus_user) { FactoryGirl.create(:user, agrees_tos: false) }

  let (:f1) {FactoryGirl.create(:fact)}
  let (:f2) {FactoryGirl.create(:fact)}
  let (:f3) {FactoryGirl.create(:fact)}

  let (:ch1) do
    ch1 = FactoryGirl.create :channel, created_by: user.graph_user
    
    [f1,f2,f3].each do |f|
      f.created_by.user = FactoryGirl.create(:user)
      f.created_by.save
    end
    
    ch1.add_fact f1
    ch1.add_fact f2
    ch1.add_fact f3
    ch1.save
    ch1
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
    
    it "as bogus user should redirect to Terms of Service page" do
      authenticate_user!(bogus_user)
      get :index, username: user.username
      response.should redirect_to(tos_path)
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
  
  describe "#facts" do
    it "should render" do
      authenticate_user!(user)
      should_check_can :show, ch1
      get :facts, username: user.username, id: ch1.id, :format => :json
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
