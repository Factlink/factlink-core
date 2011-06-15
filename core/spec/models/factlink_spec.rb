require 'spec_helper'

describe Factlink do

  before(:each) do
    @factlink = Factlink.new
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end
  
  # Should go to application test
  it "should have a redis connection" do
    $redis.should be_an_instance_of(Redis)
  end

  ##########
  # Believer tests
  it "can be instantiated" do
    Factlink.new.should be_an_instance_of(Factlink)
  end
  
  it "should have 0 believers on new Factlink when believers_count is called" do
    @factlink.believers_count.should == 0
  end
  
  it "should have 1 believer when one believer is added" do
    @factlink.add_believer @user1
    @factlink.believers_count.should == 1
  end
  
  it "should have 1 believer when the same believer is added twice" do
    @factlink.add_believer @user1
    @factlink.add_believer @user1
    @factlink.believers_count.should == 1
  end
  
  it "should have 0 believers when one believer is added and deleted" do
    @factlink.add_believer @user1
    @factlink.remove_believer @user1
    @factlink.believers_count.should == 0
  end
  
  it "should have 2 believer when two believers are added" do
    @factlink.add_believer @user1
    @factlink.add_believer @user2
    @factlink.believers_count.should == 2
  end

  it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
    @factlink.add_believer @user1
    @factlink.add_believer @user2
    @factlink.add_doubter @user1
    @factlink.believers_count.should == 1
  end
  
  it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
    @factlink.add_believer @user1
    @factlink.add_believer @user2
    @factlink.add_doubter @user1
    @factlink.add_doubter @user2
    @factlink.believers_count.should == 0
  end
  
  it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
    @factlink.add_believer @user1
    @factlink.add_believer @user2
    @factlink.add_disbeliever @user1
    @factlink.believers_count.should == 1
  end

  # Array check
  it "should have '123' in this array " do
    @factlink.arrz.should include("123")
  end
  
  # User should have a reference of all Factlink Ids he beliefs, doubts, disbeliefs
  it "should store the Factlink ID in the user object when a user believes a fact" do
    @factlink.add_believer @user1
    @user1.beliefs.should include(@factlink.id.to_s)
  end
  
  it "should store the Factlink ID in the user object when a user doubts a fact" do
    @factlink.add_doubter @user1
    @user1.doubts.should include(@factlink.id.to_s)
  end
  
  it "should store the Factlink ID in the user object when a user disbelieves a fact" do
    @factlink.add_disbeliever @user1
    @user1.disbelieves.should include(@factlink.id.to_s)
  end
  
  
  # Voting
  it "should have an increased believe count when a users believes this fact" do
    old_count = @factlink.believers_count
    @factlink.add_believer @user2
    @factlink.believers_count.should == (old_count + 1)
  end
  
  
  
end