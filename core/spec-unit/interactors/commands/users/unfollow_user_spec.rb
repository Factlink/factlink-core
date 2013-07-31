require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/unfollow_user'

describe Commands::Users::UnfollowUser do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)

      stub_classes 'UserFollowingUsers'
    end

    it 'calls a UserFollowingUsers.unfollow to unfollow user' do
      graph_user_id = double
      user_to_unfollow_graph_user_id = double
      users_following_users = double

      UserFollowingUsers.should_receive(:new).with(graph_user_id).and_return(users_following_users)
      users_following_users.should_receive(:unfollow).with(user_to_unfollow_graph_user_id)

      query = described_class.new graph_user_id: graph_user_id,
        user_to_unfollow_graph_user_id: user_to_unfollow_graph_user_id
      query.execute
    end
  end

  describe 'validations' do
    it 'requires valid graph_user_id' do
      expect_validating(graph_user_id: '', user_to_follow_graph_user_id: '1').
        to fail_validation('graph_user_id should be an integer string.')
    end

    it 'requires valid user_to_follow_graph_user_id' do
      expect_validating(graph_user_id: '12', user_to_follow_graph_user_id: '').
        to fail_validation('user_to_unfollow_graph_user_id should be an integer string.')
    end
  end
end
