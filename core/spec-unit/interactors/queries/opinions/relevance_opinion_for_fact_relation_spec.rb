require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/relevance_opinion_for_fact_relation.rb'

describe Queries::Opinions::RelevanceOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'returns the dead opinion on the fact_relation' do
      dead_opinion = mock
      fact_relation = mock(id: mock)
      fact_graph = mock
      query = described_class.new fact_relation

      FactGraph.stub new: fact_graph

      fact_graph.stub(:user_opinion_for_fact_relation).with(fact_relation)
        .and_return(dead_opinion)

      result = query.call

      expect(result).to eq dead_opinion
    end
  end
end
