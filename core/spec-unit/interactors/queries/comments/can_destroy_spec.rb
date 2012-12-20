require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/can_destroy'

describe Queries::Comments::CanDestroy do
  include PavlovSupport

  describe '.validate' do
    let(:subject_class) { Queries::Comments::CanDestroy }

    it 'validates with correct values' do
      expect_validating('1a', '20a').to_not raise_error
    end

    it 'without valid comment_id doesn''t validate' do
      expect_validating(1, '20a' 'Comment').
        to fail_validation('comment_id should be an hexadecimal string.')
    end

    it 'without valid user_id doesn''t validate' do
      expect_validating('1a', 20, 'Comment').
        to fail_validation('user_id should be an hexadecimal string.')
    end
  end

  describe '.call' do
    before do
      stub_classes 'EvidenceDeletable'
    end

    it 'calls EvidenceDeletable' do
      user = stub(id: '10a', graph_user_id: '20')
      comment_id = '1a'
      comment = stub(created_by: user, created_by_id: user.id)
      believable = stub

      query = Queries::Comments::CanDestroy.new comment_id, user.id, {}
      query.stub comment: comment, believable: believable

      deletable = mock
      deletable.should_receive(:deletable?).and_return(true)

      EvidenceDeletable.should_receive(:new).with(comment, 'Comment', believable, user.graph_user_id)
        .and_return(deletable)

      expect(query.call).to eq true
    end

    it 'returns false for a different user' do
      user = stub(id: '10a', graph_user_id: '20')
      comment_id = '1a'
      comment = stub(created_by: user, created_by_id: user.id)
      other_user = stub(id: '40a', graph_user_id: '50')

      query = Queries::Comments::CanDestroy.new comment_id, other_user.id, {}
      query.stub comment: comment, deletable: true

      expect(query.call).to eq false
    end
  end
end
