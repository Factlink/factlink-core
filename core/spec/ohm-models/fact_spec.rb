require 'spec_helper'

describe Fact do
  subject(:fact) { create :fact }

  let(:factlink) { create :fact }

  let(:graph_user) { create(:graph_user) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    Activity.stub(:create)
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

      supported_fact.add_evidence(:believes, supporting_fact, graph_user)

      expect(supported_fact.deletable?).to be_false
    end

    it "is false when the fact is used as evidence" do
      supported_fact  = Fact.create created_by: graph_user
      supporting_fact = Fact.create created_by: graph_user

      supported_fact.add_evidence(:believes, supporting_fact, graph_user)

      expect(supported_fact.deletable?).to be_false
    end

  end
end
