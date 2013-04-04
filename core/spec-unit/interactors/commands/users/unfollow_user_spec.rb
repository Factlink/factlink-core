require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/unfollow_user'

describe Commands::Users::UnfollowUser do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)

      stub_classes 'UserFollowingUsers'
    end

    it 'calls a command to follow user and returns the user' do
      user_id = mock
      user_to_unfollow_id = mock
      users_following_users = mock

      UserFollowingUsers.should_receive(:new).with(user_id).and_return(users_following_users)
      users_following_users.should_receive(:unfollow).with(user_to_unfollow_id)

      query = described_class.new user_id, user_to_unfollow_id
      query.execute
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      user_id = mock
      user_to_unfollow_id = mock

      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_id, user_id)
      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_to_unfollow_id, user_to_unfollow_id)

      query = described_class.new user_id, user_to_unfollow_id
    end
  end
end
