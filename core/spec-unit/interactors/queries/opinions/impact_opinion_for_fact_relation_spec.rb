require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/impact_opinion_for_fact_relation.rb'

describe Queries::Opinions::ImpactOpinionForFactRelation do
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

      fact_graph.stub(:impact_opinion_for_fact_relation).with(fact_relation, allow_negative_authority: true)
        .and_return(dead_opinion)

      result = query.call

      expect(result).to eq dead_opinion
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_relation = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact_relation, fact_relation)

      command = described_class.new fact_relation
    end
  end
end
