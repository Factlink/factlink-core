require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/deletable'

describe Queries::Comments::Deletable do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'EvidenceDeletable', 'Comment', 'Believable::Commentje'
    end

    it 'calls EvidenceDeletable' do
      user = double(graph_user_id: '20')
      comment_id = '1a'
      comment = double(created_by: user)
      believable = double
      deletable = double deletable?: true
      query = described_class.new comment_id: comment_id

      Comment.stub(:find).with(comment_id).and_return(comment)
      Believable::Commentje.stub(:new).with(comment).and_return(believable)
      EvidenceDeletable.stub(:new)
        .with(comment, 'Comment', believable, user.graph_user_id)
        .and_return(deletable)

      expect(query.call).to eq true
    end
  end
end
