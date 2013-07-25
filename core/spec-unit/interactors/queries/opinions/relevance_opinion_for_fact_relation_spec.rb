require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/relevance_opinion_for_fact_relation.rb'

describe Queries::Opinions::RelevanceOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::Store', 'HashStore::Redis'
    end

    it 'returns the dead opinion on the fact_relation' do
      dead_opinion = mock
      fact_relation = mock(id: mock)
      opinion_store = mock
      query = described_class.new fact_relation

      HashStore::Redis.stub new: mock
      Opinion::Store.stub(:new).with(HashStore::Redis.new)
        .and_return(opinion_store)

      opinion_store.stub(:retrieve).with(:FactRelation, fact_relation.id, :user_opinion)
        .and_return(dead_opinion)

      result = query.call

      expect(result).to eq dead_opinion
    end
  end
end
