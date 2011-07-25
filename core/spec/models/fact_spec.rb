require 'spec_helper'

describe Fact do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @factlink = FactoryGirl.create(:fact)

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
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

  it "should have working fact_relations" do
    @parent.add_evidence(:supporting,@factlink,@user1)
  end

  describe "Supporting / Weakening fact" do

    [:supporting, :weakening].each do |relation|
      def other_one(this)
        if this == :supporting
          :weakening
        else
          :supporting
        end
      end

      describe ".add_evidence" do
        describe "after adding one piece of #{relation} evidence" do
          before do
            @parent.add_evidence(relation,@factlink,@user1) 
          end
          it "should have a correct opinion" do
            @parent.get_opinion.should be_a(Opinion)
          end
        end
        
        describe "after adding cyclic relations" do
          before do
            @parent.add_evidence(relation,@factlink,@user1) 
            @factlink.add_evidence(relation,@parent,@user1) 
          end
          it "should have a correct opinion" do
            @parent.get_opinion.should be_a(Opinion)
          end
        end
      end

      it "stores the ID's of supporting facts in the supporting facts set" do
        pending
        @parent.add_evidence(relation, @factlink, @user1)
        evidence_facts = @parent.evidence(relation).members.collect { |x| FactRelation.find(x).from_fact.value } 
        evidence_facts.should include(@factlink.id.to_s)
      end

      #TODO deze fixen dat ie ook generiek is:
      it "should not store the ID of weakening facts in the supporting facts set" do
        pending
        @parent.add_evidence(other_one(this), @factlink2, @user1)
        evidence_facts = @parent.evidence(relation).members.collect { |x| FactRelation.find(x).from_fact.value } 
        evidence_facts.should_not include(@factlink2.id.to_s)
      end

      it "should store the supporting evidence ID when a FactRelation is created" do
        pending
        @fl = FactRelation.get_or_create(@factlink, relation, @parent, @user1)
        @parent.evidence(relation).members.should include(@factlink.id.to_s)
      end
    end
  end

  describe ".evidence_opinions" do
    it "should work"
  end


end