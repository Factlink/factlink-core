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
      top_topics_limit = 10
      top_user_topics = [
        DeadUserTopic.new('foo', 'Foo'),
        DeadUserTopic.new('bar', 'Bar')
      ]
      graph_user = double(id: '10', sorted_created_facts: double(size: 14))
      user = double(graph_user: graph_user, id: 'a1')
      query = described_class.new(user_ids: [0], top_topics_limit: top_topics_limit)

      User.stub(:any_in).with(_id: [0]).and_return([user])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers
        .stub(:new)
        .with(graph_user.id)
        .and_return(following_info)

      Pavlov.stub(:query)
        .with(:'user_topics/top_for_user',
                  user: user, limit_topics: top_topics_limit)
        .and_return(top_user_topics)


      result = query.call

      Approvals.verify(result.to_json, format: :json, name: 'query-users_by_ids')
    end

    it 'can search by graph_user ids' do
      graph_user_ids = [0, 1]
      graph_user0 = double(id: '10', user_id:8080, sorted_created_facts: double(size: 10))
      graph_user1 = double(id: '20', sorted_created_facts: double(size: 10))
      user0 = double(graph_user: graph_user0, id: 'a1')
      user1 = double(graph_user: graph_user1, id: 'a2')
      query = described_class.new(user_ids: graph_user_ids, by: :graph_user_id)

      User.stub(:any_in).with(graph_user_id: graph_user_ids).and_return([user0, user1])

      following_info = double(following_count: 3, followers_count: 2)
      UserFollowingUsers.stub(:new).and_return(following_info)

      Pavlov.stub(:query)

      expect(query.call.length).to eq 2
    end

  end
end
