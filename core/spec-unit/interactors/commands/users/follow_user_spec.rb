require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/follow_user'

describe Commands::Users::FollowUser do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)

      stub_classes 'UserFollowingUsers'
    end

    it 'calls a command to follow user and returns the user' do
      graph_user_id = mock
      user_to_follow_graph_user_id = mock
      users_following_users = mock

      UserFollowingUsers.should_receive(:new)
                        .with(graph_user_id)
                        .and_return(users_following_users)
      users_following_users.should_receive(:follow)
                           .with(user_to_follow_graph_user_id)

      query = described_class.new graph_user_id, user_to_follow_graph_user_id
      query.execute
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = mock
      user_to_follow_graph_user_id = mock

      described_class.any_instance.should_receive(:validate_integer_string)
                                  .with(:graph_user_id, graph_user_id)
      described_class.any_instance.should_receive(:validate_integer_string)
                                  .with(:user_to_follow_graph_user_id, user_to_follow_graph_user_id)

      query = described_class.new graph_user_id, user_to_follow_graph_user_id
    end
  end
end
