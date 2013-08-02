require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/opinion_for_fact.rb'

describe Queries::Opinions::OpinionForFact do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'returns the dead opinion on the fact' do
      dead_opinion = double
      fact = double(id: double)
      fact_graph = double
      query = described_class.new fact: fact

      FactGraph.stub new: fact_graph

      fact_graph.stub(:opinion_for_fact).with(fact)
        .and_return(dead_opinion)

      expect(query.call).to eq dead_opinion
    end
  end
end
