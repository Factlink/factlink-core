require 'spec_helper'

describe FactsController do

  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end

  describe :store_fact_for_non_signed_in_user do
    it "should work"
  end

  describe :factlinks_for_url do
    it "should work" do
      pending
      get :factlinks_for_url
      assigns[:json].should == []
    end
  end

  describe :show do
    it "should work"
  end

  describe :new do
    it "should return a fact object" do
      authenticate_user!
      get :new
      assigns[:factlink].should be_a(Fact)
    end
  end

  describe :edit do
    it "should work"
  end
  
  describe :prepare do
    it "should work"
  end
  
  describe :intermediate do
    it "should work"
  end
  
  describe :create do
    it "should work"
  end
  
  describe :add_supporting_evidence do
    it "should work"
  end
  
  describe :add_weakening_evidence do
    it "should work"
  end
  
  describe :add_factlink_to_parent_as_supporting do
    it "should work"
  end
  
  describe :add_afctlink_to_parent_as_weakening do
    it "should work"
  end
  
  describe :remove_factlink_from_parent do
    it "should work"
  end
  
  describe :update do
    it "should work"
  end
  
  describe :toggle_opinion_on_fact do
    it "should work"
  end
  
  describe :toggle_relevance_on_fact_relation do
    it "should work"
  end
  
  describe :interaction_users_for_factlink do
    it "should work"
  end
  
  describe :search do
    it "should work"
  end
  
  describe :indication do
    it "should work"
  end
  
  
end
