require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/activities/graph_user_ids_following_comments'

describe Queries::Activities::GraphUserIdsFollowingComments do
  include PavlovSupport

  before do
    stub_classes 'Backend::SubComments', 'Believable::Commentje', 'User'
  end

  describe '#call' do
    it 'returns unique follower ids' do
      comments = [
        double(id: '1', created_by: double(graph_user_id: 1)),
        double(id: '2', created_by: double(graph_user_id: 2)),
      ]

      believables = [
        double(opinionated_users_ids: 2),
        double(opinionated_users_ids: 3),
      ]

      sub_comment_posters = [
        double( id: '3a', graph_user_id: 3 ),
        double( id: '4a', graph_user_id: 4 )
      ]

      sub_comment_posters.each do |user|
        User.stub(:where).with(id: user.id).and_return [user]
      end

      sub_comments = [
        double( created_by: double( id: sub_comment_posters[0].id )),
        double( created_by: double( id: sub_comment_posters[1].id ))
      ]


      Believable::Commentje.stub(:new).with(comments[0].id).and_return(believables[0])
      Believable::Commentje.stub(:new).with(comments[1].id).and_return(believables[1])

      query = described_class.new comments: comments

      Backend::SubComments.stub(:index)
                          .with(parent_ids_in: comments.map(&:id))
                          .and_return(sub_comments)

      expect(query.call).to eq [1, 2, 3, 4]
    end
  end
end
