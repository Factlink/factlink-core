require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/follower_graph_user_ids'

describe Queries::Users::FollowerGraphUserIds do
  include PavlovSupport

  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the ids of follower' do
      graph_user_id = double
      ids = double
      users_following_users = double

      UserFollowingUsers.should_receive(:new).with(graph_user_id).and_return(users_following_users)
      users_following_users.should_receive(:followers_ids).and_return(ids)
      query = described_class.new graph_user_id: graph_user_id

      result = query.execute

      expect(result).to eq ids
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = double
      query = described_class.new graph_user_id: graph_user_id
      UserFollowingUsers.stub(:new).and_return(double(followers_ids: double))

      query.should_receive(:validate_integer_string).with(:graph_user_id, graph_user_id)

      query.call
    end
  end
end
