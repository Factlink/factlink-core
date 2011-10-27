require 'spec_helper'

describe ChannelsController do
  include Devise::TestHelpers
  render_views

  let (:user) {FactoryGirl.create(:user)}

  let (:ch1) {FactoryGirl.create(:channel)}
  let (:f1) {FactoryGirl.create(:fact)}
  let (:f2) {FactoryGirl.create(:fact)}
  let (:f3) {FactoryGirl.create(:fact)}

  # TODO factor out, because each controller needs this
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => user)
  end
  
  before do
    ch1.created_by = user.graph_user
    ch1.add_fact f1
    ch1.add_fact f2
    ch1.add_fact f3
    ch1.save
  end
  
  describe "#new" do
    it "should be succesful" do
      authenticate_user!(user)
      get :new, :username => user.username
      response.should be_succes
    end
  end

  describe "#index" do
    it "as json should be successful" do
      authenticate_user!(user)
      get :index, :username => user.username, :format => 'json'
      response.should be_succes
    end
  end
  

  describe "#show" do
    it "all should be succesful" do
      authenticate_user!(user)
      get :show, :username => user.username, :id => 'all'
      response.should be_succes
    end

    it "a channel should be succesful" do
      authenticate_user!(user)
      get :show, :username => user.username, :id => ch1.id
      response.should be_succes
    end

    it "a channel as json should be succesful" do
      authenticate_user!(user)
      get :show, :username => user.username, :id => ch1.id, :format => 'json'
      response.should be_succes
    end
  end

  
end
