require 'spec_helper'

describe Factlink do

  before(:each) do
    @parent = Factlink.new
    @factlink = Factlink.new
    @factlink2 = Factlink.new
    
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
    @parent.add_child_as_supporting(@factlink, @user1)
    @parent.childs_count.should == 1
  end

  ##########
  # Believer tests
  it "should have 0 believers on new Factlink when believer_count is called" do
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 1 believer when one believer is added" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 1 believer when the same believer is added twice" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 0 believers when one believer is added and deleted" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.remove_opinions @user1, @parent
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 2 believer when two believers are added" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.opiniated_count(:beliefs).should == 2
  end

  it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:doubter, @user1, @parent)
    @factlink.opiniated_count(:beliefs).should == 1
  end

  it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:doubts, @user1, @parent)
    @factlink.add_opinion(:doubts, @user2, @parent)
    @factlink.opiniated_count(:beliefs).should == 0
  end

  it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.add_opinion(:disbeliefs, @user1, @parent)
    @factlink.opiniated_count(:beliefs).should == 1
  end


  # User should have a reference of all Factlink Ids he beliefs, doubts, disbeliefs
  it "should store the Factlink ID in the user object when a user believes a fact" do
    @factlink.add_opinion(:beliefs, @user1, @parent)
    @user1.believe_ids.should include(@factlink.id.to_s)
  end

  it "should store the Factlink ID in the user object when a user doubts a fact" do
    @factlink.add_opinion :doubts, @user1, @parent
    @user1.doubt_ids.should include(@factlink.id.to_s)
  end

  it "should store the Factlink ID in the user object when a user disbelieves a fact" do
    @factlink.add_opinion :disbeliefs, @user1, @parent
    @user1.disbelieve_ids.should include(@factlink.id.to_s)
  end


  # Voting
  it "should have an increased believe count when a users believes this fact" do
    old_count = @factlink.opiniated_count(:beliefs)
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @factlink.opiniated_count(:beliefs).should == (old_count + 1)
  end

  it "should have the Factlink ID in the Users belief_ids when a user beliefs a fact" do
    @factlink.add_opinion(:beliefs, @user2, @parent)
    @user2.believe_ids.should include(@factlink.id.to_s)
  end

  #TODO also add tests for doubts and disbeliefs

  it "should not crash when an opinions that doesn't exist is removed" do
    @factlink.remove_opinions @user2, @parent
  end

  # Removing a child
  it "can remove a child" do
    @parent.remove_child @factlink
    @parent.childs_count.should == 0
  end

  # Supporting / Weakening fact
  it "stores the ID's of supporting facts in the supporting facts set" do
    @parent.add_child_as_supporting(@factlink, @user1)
    @parent.supporting_fact_ids.should include(@factlink.id.to_s)
  end

  it "stores the ID's of weakening facts in the weakening facts set" do
    @parent.add_child_as_weakening(@factlink2, @user1)
    @parent.weakening_fact_ids.should include(@factlink2.id.to_s)
  end

  it "should not store the ID of weakening facts in the supporting facts set" do
    @parent.add_child_as_weakening(@factlink2, @user1)
    @parent.supporting_fact_ids.should_not include(@factlink2.id.to_s)
  end
  
  it "should return true if the child is a supporting child when checking a supporting child" do
    @parent.add_child_as_supporting(@factlink, @user1)
    @parent.supported_by?(@factlink).should == true
  end

  it "should return false if the child is a supporting child when checking a weakening child" do
    @parent.add_child_as_supporting(@factlink, @user1)
    @parent.supported_by?(@factlink2).should == false
  end

  it "should return true if the child is weakening child when checking a weakning child" do
    @parent.add_child_as_weakening(@factlink2, @user1)
    @parent.weakened_by?(@factlink2).should == true
  end

  it "should return false if the child is weakening child when checking a supporting child" do
    @parent.add_child_as_weakening(@factlink2, @user1)
    @parent.weakened_by?(@factlink).should == false
  end



  it "can get a count of relevant users" do
    
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :relevant).should == 0
  end

  it "parent can set relevance for child and user" do    
    @parent.set_relevance_for_user(@factlink, :relevant, @user1)
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :relevant).should == 1
  end

  it "can remove the relevance of a child for a user" do
    @parent.set_relevance_for_user(@factlink, :relevant, @user1)
    @parent.remove_relevance_for_user(@factlink, @user1)
    
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :relevant).should == 0
  end

  it "remove the first relevance opinion when a user changes relevance of the child" do
    # Set relevant
    @parent.set_relevance_for_user(@factlink, :relevant, @user1)
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :relevant).should == 1
    
    # Set not_relevant
    @parent.set_relevance_for_user(@factlink, :not_relevant, @user1)
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :relevant).should == 0
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :not_relevant).should == 1
  end
  
  it "should have a user with relevance when set" do
    @parent.set_relevance_for_user(@factlink, :not_relevant, @user1)

    @parent.set_relevance_for_user(@factlink, :relevant, @user1)
    @parent.user_has_relevance_on_child?(@factlink, :relevant, @user1).should == true
    @parent.user_has_relevance_on_child?(@factlink, :might_be_relevant, @user1).should == false
    @parent.user_has_relevance_on_child?(@factlink, :not_relevant, @user1).should == false
  end

  it "can toggle the relevance on a child for a user" do
    @parent.set_relevance_for_user(@factlink, :not_relevant, @user1)
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :not_relevant).should == 1
    
    @parent.set_relevance_for_user(@factlink, :not_relevant, @user1)
    @parent.get_relevant_users_count_for_child_and_type(@factlink, :not_relevant).should == 0
  end

end
