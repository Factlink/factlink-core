require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/unfollow_user'

describe Commands::Users::UnfollowUser do
  include PavlovSupport
  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#call' do
    it 'calls a UserFollowingUsers.unfollow to unfollow user' do
      graph_user_id = '1'
      user_to_unfollow_graph_user_id = '4'
      users_following_users = double

      UserFollowingUsers.should_receive(:new).with(graph_user_id).and_return(users_following_users)
      users_following_users.should_receive(:unfollow).with(user_to_unfollow_graph_user_id)

      query = described_class.new graph_user_id: graph_user_id,
                                  user_to_unfollow_graph_user_id: user_to_unfollow_graph_user_id
      query.call
    end
  end
end
