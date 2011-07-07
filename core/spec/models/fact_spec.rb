require 'spec_helper'

describe Fact do

  before(:each) do
    @parent = Fact.new
    @factlink = Fact.new
    @factlink2 = Fact.new
    
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end

  # Should go to application test
  it "should have a redis connection" do
    $redis.should be_an_instance_of(Redis)
  end

  

   
   
   # Voting
   it "should have an increased believe count when a users believes this fact" do
     old_count = @factlink.opiniated_count(:beliefs)
     @factlink.add_opinion(:beliefs, @user2)
     @factlink.opiniated_count(:beliefs).should == (old_count + 1)
   end
   

   
   #TODO also add tests for doubts and disbeliefs
   
   it "should not crash when an opinions that doesn't exist is removed" do
     @factlink.remove_opinions @user2
   end

   
   # Supporting / Weakening fact
   it "stores the ID's of supporting facts in the supporting facts set" do
     @parent.add_evidence(:supporting,@factlink, @user1)
     evidence_facts = @parent.evidence(:supporting).members.collect { |x| Factlink.find(x).evidence_fact.value } 
     evidence_facts.should include(@factlink.id.to_s)
   end
   
   it "stores the ID's of weakening facts in the weakening facts set" do
     @parent.add_evidence(:weakening, @factlink2, @user1)
     evidence_facts = @parent.evidence(:weakening).members.collect { |x| Factlink.find(x).evidence_fact.value } 
     evidence_facts.should include(@factlink2.id.to_s)
   end
   
   it "should not store the ID of weakening facts in the supporting facts set" do
     @parent.add_evidence(:weakening, @factlink2, @user1)
     evidence_facts = @parent.evidence(:supporting).members.collect { |x| Factlink.find(x).evidence_fact.value } 
     evidence_facts.should_not include(@factlink2.id.to_s)
   end
   
   
end