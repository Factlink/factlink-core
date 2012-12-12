require 'spec_helper'


describe Fact do
  def self.other_one(this)
    (this == :supporting) ? :weakening : :supporting
  end

  def other_one(this)
    self.class.other_one(this)
  end

  subject(:fact) {create :fact}

  let(:parent) {create :fact}

  let(:factlink) {create :fact}
  let(:factlink2) {create :fact}

  let(:gu1) {create(:graph_user)}
  let(:gu2) {create(:graph_user)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

  context "initially" do
    it "should be findable" do
      fact.should be_a(Fact)
    end
    it "should have an authority of 1" do
      Authority.from(fact).to_f.should == 0.0
    end
    it "should be persisted" do
      Fact[fact.id].should == fact
    end
    describe ".delete" do
      it " should work" do
        old_id = fact.id
        data_id = fact.data.id
        fact.delete
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
    fact.created_by.class.should == GraphUser
  end

  it "should be in the created_facts set of the creator" do
    @gu = fact.created_by
    @gu.created_facts.to_a.should =~ [fact]
  end


  context "evidence" do
    describe "should initially be empty" do

      [:supporting, :weakening].each do |relation|
        it "should have no evidence for a type " do
          fact.evidence(relation).count.should == 0
        end
      end

      it "should have no evidence for :both type " do
        fact.evidence(:both).count.should == 0
      end
    end
  end

  [:supporting, :weakening].each do |relation|

    describe ".evidence" do
      [:supporting, :weakening, :both].each do |relation|
        it "should initially be empty" do
          fact.evidence(relation).count.should == 0
        end
      end
    end

    describe ".add_evidence" do

      context "with one #{relation} fact" do
        before do
          @fr = fact.add_evidence(relation,factlink,gu1)
        end

        its(:get_opinion) {should be_a(Opinion)}

        describe "should have one evidence" do
          it "for the relation #{relation}" do
            fact.evidence(relation).count.should == 1
          end
          it "for :both" do
            fact.evidence(:both).count.should == 1
          end
        end

        describe ".delete the fact, which has a #{relation} fact" do
          before do
            @fact_id = fact.id
            @data_id = fact.data.id
            @relation_id = @fr.id
            fact.delete
          end
          it "should remove the fact" do
            Fact[@fact_id].should be_nil
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
          fact.add_evidence(relation,factlink,gu1)
          fact.add_evidence(relation,factlink2,gu1)
        end

        it "should have two #{relation} facts" do
          fact.evidence(relation).count.should == 2
        end
        it "should have two facts for :both" do
          fact.evidence(:both).count.should == 2
        end
      end

      context "with one #{relation} fact and one #{other_one(relation)} fact" do
        before do
          fact.add_evidence(relation,factlink,gu1)
          fact.add_evidence(other_one(relation),factlink2,gu1)
        end

        it "should have one #{relation} fact" do
          fact.evidence(relation).count.should == 1
        end
        it "should have one #{other_one(relation)} fact" do
          fact.evidence(other_one(relation)).count.should == 1
        end
        it "should have two facts for :both" do
          fact.evidence(:both).count.should == 2
        end
      end
    end
  end


  describe "Mongoid properties: " do
    [:displaystring, :title].each do |attr|
      context "#{attr} should be changeable" do
        before do
          fact.data.send "#{attr}=" , "quux"
        end
        it {fact.data.send("#{attr}").should == "quux"}
      end
      context "#{attr} should persist" do
        before do
          fact.data.send "#{attr}=" , "xuuq"
          fact.data.save
        end
        it {Fact[fact.id].data.send("#{attr}").should == "xuuq"}
      end
    end
    context "after setting a displaystring to 'hiephoi'" do
      before do
        fact.data.displaystring = "hiephoi"
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
      fact.data.displaystring = '     '
      fact.data.save.should be_false
    end

    it "should not be possible to save a fact with a string consisting out of only spaces" do
      Fact.build_with_data('http://google.com/',' ', 'foo', gu1).data.save.should be_false
    end
  end



end
