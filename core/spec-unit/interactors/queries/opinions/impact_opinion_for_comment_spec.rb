require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/impact_opinion_for_comment.rb'

describe Queries::Opinions::ImpactOpinionForComment do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'returns the dead opinion on the comment' do
      dead_opinion = mock
      comment = mock(id: mock)
      fact_graph = mock
      query = described_class.new comment

      FactGraph.stub new: fact_graph

      fact_graph.stub(:impact_opinion_for_comment).with(comment)
        .and_return(dead_opinion)

      result = query.call

      expect(result).to eq dead_opinion
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      comment = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:comment, comment)

      command = described_class.new comment
    end
  end
end
