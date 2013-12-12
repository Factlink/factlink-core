require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/follow_user'

describe Commands::Users::FollowUser do
  include PavlovSupport

  describe '#execute' do
    it 'calls a UserFollowingUsers.follow to follow user' do
      stub_classes 'UserFollowingUsers'
      graph_user_id = double
      user_to_follow_graph_user_id = double
      users_following_users = double

      UserFollowingUsers.stub(:new)
                        .with(graph_user_id)
                        .and_return(users_following_users)

      users_following_users.should_receive(:follow)
                           .with(user_to_follow_graph_user_id)

      query = described_class.new graph_user_id: graph_user_id,
                                  user_to_follow_graph_user_id: user_to_follow_graph_user_id

      query.execute
    end
  end
end
