require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/impact_opinion_for_comment.rb'

describe Queries::Opinions::ImpactOpinionForComment do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'returns the dead opinion on the comment' do
      dead_opinion = double
      comment = double(id: double)
      fact_graph = double
      query = described_class.new comment: comment

      FactGraph.stub new: fact_graph

      fact_graph.stub(:impact_opinion_for_comment).with(comment, allow_negative_authority: true)
        .and_return(dead_opinion)

      result = query.call

      expect(result).to eq dead_opinion
    end
  end

  describe '#validate' do
    it 'without comment doesn\'t validate' do
      expect_validating(comment: nil)
        .to fail_validation('comment should not be nil.')
    end
  end
end
