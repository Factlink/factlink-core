require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_comments'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingComments do
  include PavlovSupport

  describe '#call' do
    it 'uniques the follower ids' do
      ids = [1, 2, 3]
      follower_ids = [1, 2, 2, 2, 2, 3]

      query = described_class.new mock

      query.should_receive(:follower_ids)
              .and_return(follower_ids)

      expect(query.call).to eq ids
    end
  end

  describe '#follower_ids' do
    it 'combines the ids of all followers' do
      comments_creators_ids = [1, 2]
      comments_opinionated_ids = [2, 3]
      sub_comments_on_comments_creators_ids = [3, 4]

      query = described_class.new mock

      query.should_receive(:comments_creators_ids)
              .and_return(comments_creators_ids)
      query.should_receive(:comments_opinionated_ids)
              .and_return(comments_opinionated_ids)
      query.should_receive(:sub_comments_on_comments_creators_ids)
              .and_return(sub_comments_on_comments_creators_ids)

      expect(query.follower_ids).to eq [1, 2, 2, 3, 3, 4]
    end
  end

  describe '#comments_creators_ids' do
    it 'returns ids of the comment creator' do
      graph_user = stub graph_user_id: 37
      comments   = [stub(created_by: graph_user)]

      query = described_class.new comments

      expect(query.comments_creators_ids).to eq [37]
    end
  end

  describe '#comments_opinionated_ids' do
    it 'returns ids of the comment opinionators' do
      believable1 = stub opinionated_users_ids: 27
      believable2 = stub opinionated_users_ids: 28
      comments    = [stub(believable: believable1),
                     stub(believable: believable2)]

      query = described_class.new comments

      expect(query.comments_opinionated_ids).to eq [27, 28]
    end
  end

  describe '#sub_comments_on_comments_creators_ids' do
    it 'returns ids of creators of subcomments of the comments' do
      stub_classes 'SubComment'

      finder = mock

      comments = [
        mock( id: '1' ),
        mock( id: '2' )
      ]

      sub_comments = [
        mock( created_by: mock( graph_user_id: 5 )),
        mock( created_by: mock( graph_user_id: 6 ))
      ]

      query = described_class.new comments

      query.stub(:comment_ids)
           .and_return(comments.map(&:id))

      Pavlov.stub(:query)
            .with(:'sub_comments/index', comments.map(&:id), 'Comment')
            .and_return(sub_comments)

      expect(query.sub_comments_on_comments_creators_ids).to eq [5, 6]
    end
  end

  describe '#comment_ids' do
    it 'returns the comments ids' do
      comments = [stub(id: '73'), stub(id: '74')]

      query = described_class.new comments

      expect(query.comment_ids).to eq comments.map(&:id)
    end
  end
end
