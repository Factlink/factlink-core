require 'spec_helper'

def other_one(this)
  if this == :supporting
    :weakening
  else
    :supporting
  end
end

describe Fact do

  subject {FactoryGirl.create :fact}

  let(:parent) {FactoryGirl.create :fact}

  let(:factlink) {FactoryGirl.create :fact}
  let(:factlink2) {FactoryGirl.create :fact}

  let(:gu1) {FactoryGirl.create(:graph_user)}
  let(:gu2) {FactoryGirl.create(:graph_user)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

  context "initially" do
    it "should be findable" do
      subject.should be_a(Fact)
    end
    it "should have an authority of 1" do
      Authority.from(subject).to_f.should == 0.0
    end
    it "should be persisted" do
      Fact[subject.id].should == subject
    end
    describe ".delete" do
      it " should work" do
        old_id = subject.id
        data_id = subject.data.id
        subject.delete
        Fact[old_id].should be_nil
        FactData.find(data_id).should be_nil
      end
    end
  end

  it "should have the GraphUser set when a opinion is added" do
    parent.add_opinion(:believes, gu1)
    parent.opiniated(:believes).to_a.should =~ [gu1]
  end

  it "should have working fact_relations" do
    parent.add_evidence(:supporting, factlink, gu1)
  end

  it "should have a creator" do
    subject.created_by.class.should == GraphUser
  end

  it "should be in the created_facts set of the creator" do
    @gu = subject.created_by
    @gu.created_facts.to_a.should =~ [subject]
  end


  context "evidence" do
    describe "should initially be empty" do

      [:supporting, :weakening].each do |relation|
        it "should have no evidence for a type " do
          subject.evidence(relation).count.should == 0
        end
      end

      it "should have no evidence for :both type " do
        subject.evidence(:both).count.should == 0
      end
    end
  end

  [:supporting, :weakening].each do |relation|

    describe ".evidence" do
      [:supporting, :weakening, :both].each do |relation|
        it "should initially be empty" do
          subject.evidence(relation).count.should == 0
        end
      end
    end

    describe ".add_evidence" do

      context "with one #{relation} fact" do
        before do
          @fr = subject.add_evidence(relation,factlink,gu1)
        end

        its(:get_opinion) {should be_a(Opinion)}

        describe "should have one evidence" do
          it "for the relation #{relation}" do
            subject.evidence(relation).count.should == 1
          end
          it "for :both" do
            subject.evidence(:both).count.should == 1
          end
        end

        describe ".delete the fact, which has a #{relation} fact" do
          before do
            @subject_id = subject.id
            @data_id = subject.data.id
            @relation_id = @fr.id
            subject.delete
          end
          it "should remove the fact" do
            Fact[@subject_id].should be_nil
          end
          it "should remove the associated factdata" do
            FactData.find(@data_id).should be_nil
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
        end
        describe ".delete the #{relation} fact" do
          before do
            @factlink_id = factlink.id
            @data_id = factlink.data.id
            @relation_id = @fr.id
            factlink.delete
          end
          it "should remove the fact" do
            Fact[@factlink_id].should be_nil
          end
          it "should remove the associated factdata" do
            FactData.find(@data_id).should be_nil
          end
          it "should remove the #{relation} factrelation" do
            FactRelation[@relation_id].should be_nil
          end
        end
      end

      context "with two #{relation} fact" do
        before do
          @fr = subject.add_evidence(relation,factlink,gu1)
          @fr2 = subject.add_evidence(relation,factlink2,gu1)
        end

        it "should have two #{relation} facts" do
          subject.evidence(relation).count.should == 2
        end
        it "should have two facts for :both" do
          subject.evidence(:both).count.should == 2
        end
      end

      context "with one #{relation} fact and one #{other_one(relation)} fact" do
        before do
          @fr = subject.add_evidence(relation,factlink,gu1)
          @fr2 = subject.add_evidence(other_one(relation),factlink2,gu1)
        end

        it "should have one #{relation} fact" do
          subject.evidence(relation).count.should == 1
        end
        it "should have one #{other_one(relation)} fact" do
          subject.evidence(other_one(relation)).count.should == 1
        end
        it "should have two facts for :both" do
          subject.evidence(:both).count.should == 2
        end
      end
    end
  end


  describe "Mongoid properties: " do
    [:displaystring, :title].each do |attr|
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
        subject.data.displaystring = "hiephoi"
      end
      its(:to_s){should == "hiephoi"}
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.create created_by: gu1
      f.data.displaystring = "This is a fact"
      f.data.save
      f.save

      f2 = Fact[f.id]

      f2.data.displaystring.should == "This is a fact"
    end
    it "should not be possible to save a fact with a string consisting out of only spaces" do
      subject.data.displaystring = '     '
      subject.data.save.should be_false
    end

    it "should not be possible to save a fact with a string consisting out of only spaces" do
      Fact.build_with_data('http://google.com/',' ', 'foo', gu1).data.save.should be_false
    end
  end



end
