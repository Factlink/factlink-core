require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_comment_user_opinion'

describe Commands::Opinions::RecalculateCommentUserOpinion do
  include PavlovSupport

  before do
    stub_classes 'FactGraph'
  end

  describe '#call' do

    it 'calls calculate_comment_when_user_opinion_changed' do
      comment = mock
      fact_graph = mock

      FactGraph.stub new: fact_graph

      fact_graph.should_receive(:calculate_comment_when_user_opinion_changed)
        .with(comment)

      command = described_class.new comment: comment
      command.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      expect_validating(comment: nil)
        .to raise_error 'comment should not be nil.'
    end
  end
end
