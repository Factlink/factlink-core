require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_comments'
require 'pavlov_helper'

describe Queries::Activities::GraphUserIdsFollowingComments do
  include PavlovSupport

  before do
    stub_classes 'SubComment'
  end

  describe '#call' do
    it 'returns unique follower ids' do
      comments = [        double(id: '1',
             created_by: double(graph_user_id: 1),
             believable: double(opinionated_users_ids: 2)
          ),        double(id: '2',
             created_by: double(graph_user_id: 2),
             believable: double(opinionated_users_ids: 3)
          )
      ]
      sub_comments = [
        double( created_by: double( graph_user_id: 3 )),
        double( created_by: double( graph_user_id: 4 ))
      ]
      query = described_class.new comments: comments

      Pavlov.stub(:old_query)
            .with(:'sub_comments/index', comments.map(&:id), 'Comment')
            .and_return(sub_comments)

      expect(query.call).to eq [1, 2, 3, 4]
    end
  end
end
