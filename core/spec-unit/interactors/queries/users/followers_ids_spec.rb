require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/followers_ids'

describe Queries::Users::FollowersIds do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.
        should_receive(:validate).
        and_return(true)

      stub_classes 'UserFollowingUsers'
    end

    it 'returns the ids of followers' do
      user_id = mock
      ids = mock
      users_following_users = mock

      UserFollowingUsers.should_receive(:new).with(user_id).and_return(users_following_users)
      users_following_users.should_receive(:followers_ids).and_return(ids)

      query = described_class.new user_id
      result = query.execute

      expect(result).to eq ids
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      user_id = mock

      described_class.any_instance.should_receive(:validate_hexadecimal_string).with(:user_id, user_id)

      query = described_class.new user_id
    end
  end
end
