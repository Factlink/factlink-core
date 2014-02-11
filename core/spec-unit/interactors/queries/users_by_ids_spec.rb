require 'pavlov_helper'
require_relative '../../../app/interactors/kill_object.rb'
require_relative '../../../app/interactors/queries/users_by_ids.rb'
require 'approvals'

describe Queries::UsersByIds do
  include PavlovSupport

  before do
    stub_classes 'User', 'UserFollowingUsers'
  end

  describe '#call' do
    it 'returns the good objects' do
      stub_classes 'GraphUser'

      user = double(id: 'a1', graph_user_id: '10')
      query = described_class.new(user_ids: [0])

      User.stub(:any_in).with(_id: [0]).and_return([user])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers
        .stub(:new)
        .with(user.graph_user_id)
        .and_return(following_info)

      result = query.call

      Approvals.verify(result.to_json, format: :json, name: 'query-users_by_ids')
    end

    it 'can search by graph_user ids' do
      graph_user_ids = [0, 1]
      stub_classes 'GraphUser'

      user0 = double(graph_user_id: graph_user_ids[0], id: 'a1')
      user1 = double(graph_user_id: graph_user_ids[1], id: 'a2')
      query = described_class.new(user_ids: graph_user_ids, by: :graph_user_id)

      User.stub(:any_in).with(graph_user_id: graph_user_ids).and_return([user0, user1])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers.stub(:new).and_return(following_info)

      Pavlov.stub(:query)

      expect(query.call.length).to eq 2
    end

  end
end
