require 'spec_helper'

describe Fact do
  subject(:fact) { create :fact }

  let(:factlink) { create :fact }

  let(:graph_user) { create(:graph_user) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    Activity.stub(:create)
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
      f = create :fact
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

  describe '#deletable?' do
    let(:graph_user) { create :graph_user }
    let(:other_graph_user) { create :graph_user }

    it "is true when a fact is just created" do
      fact = create :fact
      expect(fact.deletable?).to be_true
    end

    it "is false when people have given their opinion on the fact" do
      fact = create :fact

      fact.add_opiniated :believes, other_graph_user

      expect(fact.deletable?).to be_false
    end

    it "is false when a comment has been given" do
      fact = create :fact

      Pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, content: 'foo', pavlov_options: {current_user: (create :user)})

      expect(fact.deletable?).to be_false
    end
  end

  describe 'delete' do
    include PavlovSupport

    it "raises when deletable? is false" do
      fact = create :fact
      fact.stub deletable?: false
      expect do
        fact.delete
      end.to raise_error
    end

    it "deletes the fact data" do
      fact = create :fact, data: (create :fact_data)
      fact_data_id = fact.data.id
      fact.delete
      expect(FactData.find(fact_data_id)).to be_nil
    end

    it "deletes the fact from the search" do
      ElasticSearch.stub synchronous: true

      fact = create :fact, data: (create :fact_data, displaystring: 'gekke gerrit is een hond')
      as(create :user) do |p|
        results = p.query(:elastic_search_fact_data, keywords: 'gerrit', page: 1, row_count: 10)
        expect(results.length).to eq 1
      end
      fact.delete
      as(create :user) do |p|
        results = p.query(:elastic_search_fact_data, keywords: 'gerrit', page: 1, row_count: 10)
        expect(results.length).to eq 0
      end
    end
  end
end
