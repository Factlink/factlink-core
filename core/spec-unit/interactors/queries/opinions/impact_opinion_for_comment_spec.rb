require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/impact_opinion_for_comment.rb'
require_relative '../../../../app/entities/dead_opinion.rb'
require_relative '../../../../app/classes/opinion_type.rb'

describe Queries::Opinions::ImpactOpinionForComment do
  include PavlovSupport

  before do
    stub_classes 'Comment'
  end

  describe '#call' do
    it 'returns the dead opinion on the comment' do
      dead_opinion = DeadOpinion.new(0.25, 0.75, 0.0, 4.0)
      believable = double(dead_opinion: dead_opinion)
      alive_comment = double(id: '1', type: 'disbelieves', believable: believable)
      dead_comment = double(id: '1')
      query = described_class.new comment: dead_comment

      Comment.stub(:find).with(dead_comment.id).and_return(alive_comment)

      expect(query.call).to eq DeadOpinion.new(0, 1, 0, -2.0)
    end
  end

  describe '#validate' do
    it 'without comment doesn\'t validate' do
      expect_validating(comment: nil)
        .to fail_validation('comment should not be nil.')
    end
  end
end
