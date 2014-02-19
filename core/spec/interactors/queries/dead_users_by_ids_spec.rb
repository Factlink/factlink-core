require 'spec_helper'

describe Queries::DeadUsersByIds do
  include PavlovSupport

  before do
    stub_classes 'User', 'UserFollowingUsers'
  end

  describe '#call' do
    it 'returns the good objects' do
      stub_classes 'GraphUser'

      user = double(:user, id: 'a1', graph_user_id: '10', name: "Mark IJbema", username: "mark", gravatar_hash: "a6af", deleted: false)
      query = described_class.new(user_ids: [0])

      User.stub(:any_in).with(_id: [0]).and_return([user])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers
        .stub(:new)
        .with(user.graph_user_id)
        .and_return(following_info)

      verify { query.call.to_json }
    end

    it 'can search by graph_user ids' do
      graph_user_ids = [0, 1]
      stub_classes 'GraphUser'

      user0 = double(graph_user_id: graph_user_ids[0], id: 'a1', name: "Mark IJbema", username: "mark", gravatar_hash: "a6af", deleted: false)
      user1 = double(graph_user_id: graph_user_ids[1], id: 'a2', name: "Tom de Vries", username: "tomdev", gravatar_hash: "b6bf", deleted: false)
      query = described_class.new(user_ids: graph_user_ids, by: :graph_user_id)

      User.stub(:any_in).with(graph_user_id: graph_user_ids).and_return([user0, user1])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers.stub(:new).and_return(following_info)

      Pavlov.stub(:query)

      expect(query.call.length).to eq 2
    end

  end
end
