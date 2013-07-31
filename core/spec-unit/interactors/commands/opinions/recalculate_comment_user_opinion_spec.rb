require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_comment_user_opinion'

describe Commands::Opinions::RecalculateCommentUserOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'calls calculate_comment_when_user_opinion_changed' do
      comment = double
      fact_graph = double

      FactGraph.stub new: fact_graph

      fact_graph.should_receive(:calculate_comment_when_user_opinion_changed)
        .with(comment)

      command = described_class.new comment
      result = command.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      comment = double

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:comment, comment)

      command = described_class.new comment
    end
  end
end
