require 'spec_helper'

describe User do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @child1 = FactoryGirl.create(:fact)
    @child2 = FactoryGirl.create(:fact)

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    
    @factlink = FactoryGirl.create(:fact)
    @factlink2 = FactoryGirl.create(:fact)
  end

  it "should have zero active factlinks on create" do
    @user1.active_on_factlinks.count.should == 0
  end

  it "should have one active factlink after adding believe" do
    @child1.add_opinion(:beliefs, @user1)
    @user1.active_on_factlinks.count.should == 1
  end

  it "should have a toggle value for the factlink key it voted on" do
    @child1.add_opinion(:beliefs, @user1)
    @user1.get_opinion(@child1)
  end
   
   # User should have a reference of all Fact Ids he beliefs, doubts, disbeliefs
   it "should store the Fact ID in the user object when a user believes a fact" do
     @factlink.add_opinion(:beliefs, @user1 )
     @user1.believe_ids.should include(@factlink.id.to_s)
   end
   
   it "should store the Fact ID in the user object when a user doubts a fact" do
     @factlink.add_opinion :doubts, @user1 
     @user1.doubt_ids.should include(@factlink.id.to_s)
   end
   
   it "should store the Fact ID in the user object when a user disbelieves a fact" do
     @factlink.add_opinion :disbeliefs, @user1
     @user1.disbelieve_ids.should include(@factlink.id.to_s)
   end
   
   it "should have the Fact ID in the Users belief_ids when a user beliefs a fact" do
     @factlink.add_opinion(:beliefs, @user2)
     @user2.believe_ids.should include(@factlink.id.to_s)
   end   
   
end
