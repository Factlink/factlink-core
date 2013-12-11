require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/follower_count'

describe Queries::Users::FollowerCount do
  include PavlovSupport

  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#execute' do
    it 'returns the number of followers' do
      graph_user_id = double
      count = double
      users_following_users = double(followers_count: count)
      query = described_class.new graph_user_id: graph_user_id

      UserFollowingUsers.stub(:new).with(graph_user_id)
        .and_return(users_following_users)

      expect(query.execute).to eq count
    end
  end
end
