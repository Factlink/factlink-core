require 'spec_helper'

describe Fact do

  subject {FactoryGirl.create(:fact)}

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

  context "initially" do
    it "should be findable" do
      subject.should be_a(Fact)
    end
    it "should be persisted" do
      Fact[subject.id].should == subject
    end
    describe ".delete_cascading" do
      it " should work" do
        old_id = subject.id
        data_id = subject.data.id
        subject.delete_cascading
        Fact[old_id].should be_nil
        expect {FactData.find(data_id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end


  it "should have working fact_relations" do
    @parent.add_evidence(:supporting,@factlink,@user1)
  end


  [:supporting, :weakening].each do |relation|
    def other_one(this)
      if this == :supporting
        :weakening
      else
        :supporting
      end
    end

    describe ".add_evidence" do

      it "should not crash when adding cyclic relations" do
        @parent.add_evidence(relation,@factlink,@user1) 
        @factlink.add_evidence(relation,@parent,@user1) 
        @parent.get_opinion.should be_a(Opinion)
      end


      context "with one #{relation} fact" do
        before do
          @fr = subject.add_evidence(relation,@factlink,@user1)
        end

        its(:get_opinion) {should be_a(Opinion)}

        describe ".delete_cascading the supported fact" do
          before do
            @subject_id = subject.id
            @data_id = subject.data.id
            @relation_id = @fr.id
          end
          it "should remove the fact" do
            Fact[@subject_id].should be_nil
          end
          it "should remove the associated factdata" do
            expect {FactData.find(data_id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
        end
        describe ".delete_cascading the supporting fact" do
          before do
            @factlink_id = @factlink.id
            @data_id = @factlink.data.id
            @relation_id = @fr.id
          end
          it "should remove the fact" do
            Fact[@subject_id].should be_nil
          end
          it "should remove the associated factdata" do
            expect {FactData.find(data_id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
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


  describe ".evidence_opinions" do
    it "should work"
  end

  describe ".delete" do

    it "should work on a fact which is supported by one fact"
    it "should work on a fact which is weakened by one fact"
    it "should work on a fact which is supported by multiple facts"
    it "should work on a fact which is weakened by multiple facts"
    it "should work on a fact which is both supported and weakened"
    it "should work on a fact which supports another fact"
    it "should work on a fact which weakens another fact"
    it "should work on a fact which supports another fact, and weakens another fact"
  end

  describe "Mongoid properties: " do
    [:displaystring, :title, :passage, :content].each do |attr|
      context "#{attr} should be changeable" do
        before do
          subject.send "#{attr}=" , "quux"
        end
        it {subject.send("#{attr}").should == "quux"}
      end
      context "#{attr} should persist" do
        before do
          subject.send "#{attr}=" , "xuuq"
          subject.save
        end
        it {Fact[subject.id].send("#{attr}").should == "xuuq"}
      end
    end
    context "after setting a displaystring to 'hiephoi'" do
      before do
        subject.displaystring = "hiephoi"\
      end
      its(:to_s){should == "hiephoi"}
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.new
      f.displaystring = "This is a fact"
      f.created_by = user
      f.save

      f2 = Fact[f.id]

      f2.displaystring.should == "This is a fact"
    end
  end


end