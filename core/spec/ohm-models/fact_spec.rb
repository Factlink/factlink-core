require 'spec_helper'
require_relative 'believable_shared'

describe Fact do
  it_behaves_like 'a believable object'

  def self.other_one(this)
    this == :supporting ? :weakening : :supporting
  end

  def other_one(this)
    self.class.other_one(this)
  end

  subject(:fact) {create :fact}

  let(:parent) {create :fact}

  let(:factlink) {create :fact}

  let(:gu1) {create(:graph_user)}
  let(:gu2) {create(:graph_user)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  context "initially" do
    it "should be findable" do
      expect(fact).to be_a(Fact)
    end
    it "should have an authority of 1" do
      expect(Authority.from(fact).to_f).to eq 0.0
    end
    it "should be persisted" do
      expect(Fact[fact.id]).to eq fact
    end
    describe ".delete" do
      it " should work" do
        old_id = fact.id
        data_id = fact.data.id
        fact.delete
        expect(Fact[old_id]).to be_nil
        expect(FactData.find(data_id)).to be_nil
      end
    end
  end

  it "should have the GraphUser set when a opinion is added" do
    parent.add_opinion(:believes, gu1)
    expect(parent.opiniated(:believes).to_a).to match_array [gu1]
  end

  it "should have a creator" do
    expect(fact.created_by.class).to eq GraphUser
  end

  it "should be in the created_facts set of the creator" do
    gu = fact.created_by
    expect(gu.created_facts.to_a).to match_array [fact]
  end


  context "initially" do
    it "should have no evidence for a type, or the :both type" do
      [:supporting, :weakening].each do |relation|
        expect(fact.evidence(relation).count).to eq 0
      end
      expect(fact.evidence(:both).count).to eq 0
    end
  end

  [:supporting, :weakening].each do |relation|

    describe ".evidence" do
      [:supporting, :weakening, :both].each do |relation|
        it "should initially be empty" do
          expect(fact.evidence(relation).count).to eq 0
        end
      end
    end

    describe ".add_evidence" do

      context "with one #{relation} fact" do
        before do
          @fr = fact.add_evidence(relation,factlink,gu1)
        end

        describe "should have one evidence" do
          it "for the relation #{relation}" do
            expect(fact.evidence(relation).count).to eq 1
          end
          it "for :both" do
            expect(fact.evidence(:both).count).to eq 1
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
            expect(Fact[@fact_id]).to be_nil
          end
          it "should remove the associated factdata" do
            expect(FactData.find(@data_id)).to be_nil
          end
          it "should remove the #{relation} factrelation" do
            expect(FactRelation[@relation_id]).to be_nil
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
            expect(Fact[@factlink_id]).to be_nil
          end
          it "should remove the associated factdata" do
            expect(FactData.find(@data_id)).to be_nil
          end
          it "should remove the #{relation} factrelation" do
            expect(FactRelation[@relation_id]).to be_nil
          end
        end
      end

      context "with two #{relation} fact" do
        it "should have two #{relation} facts and two facts for :both" do

          factlink2 = create :fact

          fact.add_evidence(relation,factlink,gu1)
          fact.add_evidence(relation,factlink2,gu1)

          expect(fact.evidence(relation).count).to eq 2
          expect(fact.evidence(:both).count).to eq 2
        end
      end

      context "with one #{relation} fact and one #{other_one(relation)} fact" do
        it "should have one #{relation}, one #{other_one(relation)} fact and two for :both" do
          factlink2 = create :fact

          fact.add_evidence(relation,factlink,gu1)
          fact.add_evidence(other_one(relation),factlink2,gu1)

          expect(fact.evidence(relation).count).to eq 1
          expect(fact.evidence(other_one(relation)).count).to eq 1
          expect(fact.evidence(:both).count).to eq 2
        end
      end
    end
  end


  describe "Mongoid properties: " do
    [:displaystring, :title].each do |attr|
      it "#{attr} should be changeable" do
        fact.data.send "#{attr}=" , "quux"
        fact.data.send("#{attr}").should == "quux"
      end
      it "#{attr} persists" do
        fact.data.send "#{attr}=" , "xuuq"
        fact.data.save
        Fact[fact.id].data.send("#{attr}").should == "xuuq"
      end
    end
    context "after setting a displaystring to 'hiephoi'" do
      it "the facts to_s is 'hiephoi'" do
        fact.data.displaystring = "hiephoi"
        expect(fact.to_s).to eq "hiephoi"
      end
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.create created_by: gu1
      f.data.displaystring = "This is a fact"
      f.data.save
      f.save

      f2 = Fact[f.id]

      expect(f2.data.displaystring).to eq "This is a fact"
    end
    it "should not be possible to save a fact with a string consisting out of only spaces" do
      fact.data.displaystring = '     '
      expect(fact.data.save).to be_false
    end

    it "should not be possible to save a fact with a string consisting out of only spaces" do
      Fact.build_with_data('http://google.com/',' ', 'foo', gu1).data.save.should be_false
    end

    describe ".created_at" do
      it 'returns the created_at of the FactData in Ohm format (UTC string)' do
        expect(fact.created_at).to be_a String
        expect(fact.created_at).to eq(fact.data.created_at.utc.to_s)
      end

      it 'returns nil when there is no FactData' do
        fact.data = nil

        expect(fact.created_at).to eq(nil)
      end
    end
  end

  describe '.has_site?' do
    it "returns false when no site is specified" do
      fact = create :fact, site: nil
      expect(fact.has_site?).to be_false
    end
    it "returns false when the site has no url" do
      fact = create :fact, site: (create :site, url: nil)
      expect(fact.has_site?).to be_false
    end
    it "returns false when the site has a blank url" do
      fact = create :fact, site: (create :site, url: ' ')
      expect(fact.has_site?).to be_false
    end
  end

end
