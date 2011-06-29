require 'spec_helper'

describe Factlink do

  before(:each) do
    @parent = Factlink.new
    @factlink = Factlink.new

    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end
  
  # Should go to application test
  it "should have a redis connection" do
    $redis.should be_an_instance_of(Redis)
  end

  it "has no childs when created" do
    @parent.childs_count.should == 0
  end

  it "can add a child" do    
    @parent.add_child(@factlink)
    @parent.childs_count.should == 1
  end

  ##########
  # Believer tests  
  it "should have 0 believers on new Factlink when believer_count is called" do
    @factlink.believer_count.should == 0
  end
  
  it "should have 1 believer when one believer is added" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.believer_count.should == 1
  end
  
  it "should have 1 believer when the same believer is added twice" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.believer_count.should == 1
  end
  
  it "should have 0 believers when one believer is added and deleted" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.remove_opinions @user1, @parent
    @factlink.believer_count.should == 0
  end
  
  it "should have 2 believer when two believers are added" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.believer_count.should == 2
  end

  it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:doubter, @user1, @parent)
    @factlink.believer_count.should == 1
  end
  
  it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:doubts, @user1, @parent)
    @factlink.add_opinion(:doubts, @user2, @parent)
    @factlink.believer_count.should == 0
  end
  
  it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:disbeliefs, @user1, @parent)
    @factlink.believer_count.should == 1
  end

  
  # User should have a reference of all Factlink Ids he beliefs, doubts, disbeliefs
  it "should store the Factlink ID in the user object when a user believes a fact" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @user1.believe_ids.should include(@factlink.id.to_s)
  end
  
  it "should store the Factlink ID in the user object when a user doubts a fact" do
    @factlink.add_doubter @user1, @parent
    @user1.doubt_ids.should include(@factlink.id.to_s)
  end
  
  it "should store the Factlink ID in the user object when a user disbelieves a fact" do
    @factlink.add_disbeliever @user1, @parent
    @user1.disbelieve_ids.should include(@factlink.id.to_s)
  end
  
  
  # Voting
  it "should have an increased believe count when a users believes this fact" do
    old_count = @factlink.believer_count
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.believer_count.should == (old_count + 1)
  end
  
  it "should have the Factlink ID in the Users belief_ids when a user beliefs a fact" do
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @user2.believe_ids.should include(@factlink.id.to_s)
  end
  
  it "should not crash when an opinions that doesn't exist is removed" do
    @factlink.remove_opinions @user2, @parent
  end
  
  # Removing a child
  it "can remove a child" do
    @parent.remove_child(@factlink)
    @parent.childs_count.should == 0
  end
  
end


describe User do
  
  before(:each) do
    @parent = Factlink.new
    @child1 = Factlink.new
    @child2 = Factlink.new

    @parent.childs << @child1
    @parent.childs << @child2

    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya") 
  end
  
  it "should have one child" do
    @parent.childs_count.should == 2
  end
  
  it "should have one first child which is the first child" do
    @parent.childs.first == @child1
  end
  
  it "should have zero active factlinks on create" do
    @user1.active_on_factlinks.count.should == 0
  end
  
  it "should have one active factlink after adding believe" do
    @child1.add_opinion(:beliefs, @user1, @parent)
    @user1.active_on_factlinks.count.should == 1
  end

  it "should have a toggle value for the factlink key it voted on" do
    @child1.add_opinion(:beliefs, @user1, @parent)
    @user1.get_opinion(@child1, @parent)
  end

end