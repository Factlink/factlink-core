require 'spec_helper'

describe Fact do

  subject {FactoryGirl.create(:fact)}

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @factlink = FactoryGirl.create(:fact)

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
  end


  context "initially" do
    it "should be findable" do
      subject.should be_a(Fact)
    end
    it "should have an influencing authority of 1" do
      subject.influencing_authority.should == 1.0
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
  
  it "should have the GraphUser set when a opinion is added" do
    @parent.add_opinion(:beliefs, @user1.graph_user)
    @parent.opiniated(:beliefs).to_a.should =~ [@user1.graph_user]
  end

  it "should have working fact_relations" do
    @parent.add_evidence(:supporting, @factlink, @user1)
  end

  it "should have a creator" do
    subject.created_by.class.should == GraphUser
  end

  it "should be in the created_facts set of the creator" do
    @gu = subject.created_by
    @gu.created_facts.to_a.should =~ [subject]
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

      context "with one #{relation} fact" do
        before do
          @fr = subject.add_evidence(relation,@factlink,@user1)
        end

        its(:get_opinion) {should be_a(Opinion)}

        describe ".delete_cascading the fact, which has a #{relation} fact" do
          before do
            @subject_id = subject.id
            @data_id = subject.data.id
            @relation_id = @fr.id
            subject.delete_cascading
          end
          it "should remove the fact" do
            Fact[@subject_id].should be_nil
          end
          it "should remove the associated factdata" do
            expect {FactData.find(@data_id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
        end
        describe ".delete_cascading the #{relation} fact" do
          before do
            @factlink_id = @factlink.id
            @data_id = @factlink.data.id
            @relation_id = @fr.id
            @factlink.delete_cascading
          end
          it "should remove the fact" do
            Fact[@factlink_id].should be_nil
          end
          it "should remove the associated factdata" do
            expect {FactData.find(@data_id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
        end
      end
    end
  end
  

  describe "Mongoid properties: " do
    [:displaystring, :title, :passage, :content].each do |attr|
      context "#{attr} should be changeable" do
        before do
          subject.data.send "#{attr}=" , "quux"
        end
        it {subject.data.send("#{attr}").should == "quux"}
      end
      context "#{attr} should persist" do
        before do
          subject.data.send "#{attr}=" , "xuuq"
          subject.data.save
        end
        it {Fact[subject.id].data.send("#{attr}").should == "xuuq"}
      end
    end
    context "after setting a displaystring to 'hiephoi'" do
      before do
        subject.data.displaystring = "hiephoi"\
      end
      its(:to_s){should == "hiephoi"}
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.create(
        :created_by => @user1.graph_user
      )
      f.data.displaystring = "This is a fact"
      f.data.save
      f.save

      f2 = Fact[f.id]

      f2.data.displaystring.should == "This is a fact"
    end
  end
  


end