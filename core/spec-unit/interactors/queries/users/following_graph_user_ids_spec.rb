require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/following_graph_user_ids'

describe Queries::Users::FollowingGraphUserIds do
  include PavlovSupport

  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#execute' do
    it 'returns the ids of users that the specified user is following' do
      graph_user_id = double
      ids = double
      users_following_users = double

      UserFollowingUsers.should_receive(:new).with(graph_user_id).and_return(users_following_users)
      users_following_users.should_receive(:following_ids).and_return(ids)

      query = described_class.new graph_user_id: graph_user_id
      result = query.call

      expect(result).to eq ids
    end
  end
end
