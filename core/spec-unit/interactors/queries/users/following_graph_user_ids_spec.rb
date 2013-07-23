require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/following_graph_user_ids'

describe Queries::Users::FollowingGraphUserIds do
  include PavlovSupport

  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the ids of users that the specified user is following' do
      graph_user_id = mock
      ids = mock
      users_following_users = mock

      UserFollowingUsers.should_receive(:new).with(graph_user_id).and_return(users_following_users)
      users_following_users.should_receive(:following_ids).and_return(ids)

      query = described_class.new graph_user_id: graph_user_id
      result = query.call

      expect(result).to eq ids
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = mock
      UserFollowingUsers.stub(:new).and_return(double(following_ids: nil))
      query = described_class.new graph_user_id: graph_user_id

      query.should_receive(:validate_integer_string).with(:graph_user_id, graph_user_id)

      query.call
    end
  end
end
