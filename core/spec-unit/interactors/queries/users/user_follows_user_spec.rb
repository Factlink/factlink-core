require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/user_follows_user'

describe Queries::Users::UserFollowsUser do
  include PavlovSupport

  before do
    stub_classes 'UserFollowingUsers'
  end

  describe '#call' do
    it 'returns true if from_user follows to_user' do
      from_graph_user_id = '1'
      to_graph_user_id = '2'
      users_following_users = double
      query = described_class.new from_graph_user_id: from_graph_user_id, to_graph_user_id: to_graph_user_id

      UserFollowingUsers.stub(:new).with(from_graph_user_id)
        .and_return(users_following_users)

      users_following_users.stub(:follows?).with(to_graph_user_id).and_return(true)

      expect(query.call).to eq true
    end

    it "returns false if from_user doesn't follow to_user" do
      from_graph_user_id = '1'
      to_graph_user_id = '2'
      users_following_users = double
      query = described_class.new from_graph_user_id: from_graph_user_id, to_graph_user_id: to_graph_user_id

      UserFollowingUsers.stub(:new).with(from_graph_user_id)
        .and_return(users_following_users)

      users_following_users.stub(:follows?).with(to_graph_user_id).and_return(false)

      expect(query.call).to eq false
    end
  end
end
