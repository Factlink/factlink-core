require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/can_destroy'

describe Queries::Comments::CanDestroy do
  include PavlovSupport

  describe 'validation' do
    it 'without valid comment_id doesn''t validate' do
      expect_validating(comment_id: 1, user_id: '20a')
        .to fail_validation('comment_id should be an hexadecimal string.')
    end

    it 'without valid user_id doesn''t validate' do
      expect_validating(comment_id: '1a', user_id: 20)
        .to fail_validation('user_id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'EvidenceDeletable'
    end

    it 'calls EvidenceDeletable' do
      user = double(id: '10a', graph_user_id: '20')
      comment_id = '1a'
      comment = double(created_by: user, created_by_id: user.id)
      believable = double
      query = described_class.new comment_id: comment_id,
        user_id: user.id

      query.stub comment: comment, believable: believable
      deletable = double
      deletable.should_receive(:deletable?).and_return(true)
      EvidenceDeletable.should_receive(:new)
        .with(comment, 'Comment', believable, user.graph_user_id)
        .and_return(deletable)

      expect(query.call).to eq true
    end

    it 'returns false for a different user' do
      user = double(id: '10a', graph_user_id: '20')
      comment_id = '1a'
      comment = double(created_by: user, created_by_id: user.id)
      other_user = double(id: '40a', graph_user_id: '50')
      query = described_class.new comment_id: comment_id, user_id: other_user.id

      query.stub comment: comment, deletable: true

      expect(query.call).to eq false
    end
  end
end
