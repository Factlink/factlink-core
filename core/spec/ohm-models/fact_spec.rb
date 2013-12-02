require 'spec_helper'

describe Fact do
  def self.other_one(this)
    this == :supporting ? :weakening : :supporting
  end

  def other_one(this)
    self.class.other_one(this)
  end

  subject(:fact) { create :fact }

  let(:factlink) { create :fact }

  let(:graph_user) { create(:graph_user) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  describe ".delete" do
    it "works" do
      old_id = fact.id
      data_id = fact.data.id

      fact.delete

      expect(Fact[old_id]).to be_nil
      expect(FactData.find(data_id)).to be_nil
    end

    it "removes the fact from the creators facts list" do
      gu = fact.created_by
      expect(gu.sorted_created_facts.count).to eq 1

      fact.delete
      expect(gu.sorted_created_facts.count).to eq 0
    end
  end

  it "has the GraphUser set when a opinion is added" do
    parent = create :fact
    parent.add_opinion(:believes, graph_user)
    expect(parent.opiniated(:believes).to_a).to match_array [graph_user]
  end

  context "initially" do
    it "should have no evidence for a type, or the :both type" do
      expect(fact.evidence(:supporting).count).to eq 0
      expect(fact.evidence(:weakening).count).to eq 0
      expect(fact.evidence(:both).count).to eq 0
    end
  end

  [:supporting, :weakening].each do |relation|
    describe ".add_evidence" do

      context "with one #{relation} fact" do
        before do
          @fr = fact.add_evidence(relation,factlink,graph_user)
        end

        describe "should have one evidence" do
          it "for the relation #{relation}" do
            expect(fact.evidence(relation).count).to eq 1
          end
          it "for :both" do
            expect(fact.evidence(:both).count).to eq 1
          end
        end
      end

      context "with two #{relation} fact" do
        it "should have two #{relation} facts and two facts for :both" do

          factlink2 = create :fact

          fact.add_evidence(relation,factlink,graph_user)
          fact.add_evidence(relation,factlink2,graph_user)

          expect(fact.evidence(relation).count).to eq 2
          expect(fact.evidence(:both).count).to eq 2
        end
      end

      context "with one #{relation} fact and one #{other_one(relation)} fact" do
        it "should have one #{relation}, one #{other_one(relation)} fact and two for :both" do
          factlink2 = create :fact

          fact.add_evidence(relation,factlink,graph_user)
          fact.add_evidence(other_one(relation),factlink2,graph_user)

          expect(fact.evidence(relation).count).to eq 1
          expect(fact.evidence(other_one(relation)).count).to eq 1
          expect(fact.evidence(:both).count).to eq 2
        end
      end
    end
  end


  describe "Mongoid properties: " do
    context "after setting a displaystring to 'hiephoi'" do
      it "the facts to_s is 'hiephoi'" do
        fact.data.displaystring = "hiephoi"
        expect(fact.to_s).to eq "hiephoi"
      end
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.create created_by: graph_user
      f.data.displaystring = "This is a fact"
      f.data.save
      f.save

      f2 = Fact[f.id]

      expect(f2.data.displaystring).to eq "This is a fact"
    end

    describe ".created_at" do
      it 'returns the created_at of the FactData in Ohm format (UTC string)' do
        expect(fact.created_at).to be_a String
        expect(fact.created_at).to eq(fact.data.created_at.utc.to_s)
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

  it 'creating a fact adds to graph_users sorted_created_facts' do
    fact = Fact.create created_by: graph_user

    expect(graph_user.sorted_created_facts.to_a).to match_array [fact]
  end

  describe "people believes redis keys" do
    it "should be cleaned up after delete" do
      fact = Fact.create created_by: graph_user
      key = fact.key['people_believes'].to_s
      fact.add_opinion(:believes, graph_user)
      redis = Redis.current
      expect(redis.smembers(key)).to eq [graph_user.id]

      fact.delete

      expect(redis.smembers(key)).to eq []
    end
  end

  describe '#deletable?' do
    let(:graph_user) { create :graph_user }
    let(:other_graph_user) { create :graph_user }

    it "is true when a fact is just created" do
      fact = Fact.create created_by: graph_user
      expect(fact.deletable?).to be_true
    end

    it "is false when people have given their opinion on the fact" do
      fact = Fact.create created_by: graph_user

      fact.add_opiniated :believes, other_graph_user

      expect(fact.deletable?).to be_false
    end

    it "is true when only the creator has given his opinion" do
      fact = Fact.create created_by: graph_user

      fact.add_opiniated :believes, graph_user

      expect(fact.deletable?).to be_true
    end

    it "lets delete raise when it is false" do
      fact = Fact.create created_by: graph_user

      fact.add_opiniated :believes, other_graph_user

      expect do
        fact.delete
      end.to raise_error
    end

    it "is false when the fact has evidence" do
      supported_fact  = Fact.create created_by: graph_user
      supporting_fact = Fact.create created_by: graph_user

      supported_fact.add_evidence(:supporting, supporting_fact, graph_user)

      expect(supported_fact.deletable?).to be_false
    end

    it "is false when the fact is used as evidence" do
      supported_fact  = Fact.create created_by: graph_user
      supporting_fact = Fact.create created_by: graph_user

      supported_fact.add_evidence(:supporting, supporting_fact, graph_user)

      expect(supported_fact.deletable?).to be_false
    end

  end
end
