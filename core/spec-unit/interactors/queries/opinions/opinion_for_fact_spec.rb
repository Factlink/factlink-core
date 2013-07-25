require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/opinion_for_fact.rb'

describe Queries::Opinions::OpinionForFact do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::Store', 'HashStore::Redis'
    end

    it 'returns the dead opinion on the fact' do
      dead_opinion = mock
      fact = mock(id: mock)
      opinion_store = mock

      HashStore::Redis.stub new: mock
      Opinion::Store.stub(:new).with(HashStore::Redis.new)
        .and_return(opinion_store)

      opinion_store.stub(:retrieve).with(:Fact, fact.id, :opinion)
        .and_return(dead_opinion)

      query = described_class.new fact
      result = query.call

      expect(result).to eq dead_opinion
    end
  end
end
