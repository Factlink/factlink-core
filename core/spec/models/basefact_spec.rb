require 'spec_helper'

describe Basefact do

  before(:each) do
    @factlink = Fact.new
    @factlink2 = Fact.new
    
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end

  ##########
  # Believer tests
  it "should have 0 believers on new Fact when believer_count is called" do
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 1 believer when one believer is added" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 1 believer when the same believer is added twice" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 0 believers when one believer is added and deleted" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.remove_opinions @user1
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 2 believer when two believers are added" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.add_opinion(:beliefs, @user2)
    @factlink.opiniated_count(:beliefs).should == 2
  end

  it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.add_opinion(:beliefs, @user2)
    @factlink.add_opinion(:doubter, @user1)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.add_opinion(:beliefs, @user2)
    @factlink.add_opinion(:doubts, @user1)
    @factlink.add_opinion(:doubts, @user2)
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
    @factlink.add_opinion(:beliefs, @user1)
    @factlink.add_opinion(:beliefs, @user2)
    @factlink.add_opinion(:disbeliefs, @user1)
    @factlink.opiniated_count(:beliefs).should == 1
  end
  
end