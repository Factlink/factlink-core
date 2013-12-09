require 'pavlov_helper'
require_relative '../../../app/interactors/kill_object.rb'
require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect_validating(user_ids: ['g6'])
      .to fail_validation 'id should be an hexadecimal string.'
  end

  describe '#call' do
    it 'should work with an empty list of ids' do
      query = described_class.new(user_ids: [])

      User.stub(:any_in).with(_id: []).and_return([])

      expect(query.call).to eq []
    end

    it 'adds user topics' do
      top_user_topics = double
      top_topics_limit = 10

      graph_user = double(id: '10', sorted_created_facts: double(size: 10))
      user = double(graph_user: graph_user, id: 'a1')
      query = described_class.new(user_ids: [0], top_topics_limit: top_topics_limit)

      User.stub(:any_in).with(_id: [0]).and_return([user])

      Pavlov.stub(:query)
      Pavlov.stub(:query)
        .with(:'user_topics/top_for_user',
                  user_id: user.id, limit_topics: top_topics_limit)
        .and_return(top_user_topics)

      expect(query.call[0].top_user_topics).to eq top_user_topics
    end

    it 'adds statistics' do
      follower_count = 123
      following_count = 456
      created_fact_count = 10
      graph_user = double(id: '10', sorted_created_facts: double(size: created_fact_count))
      user = double(graph_user: graph_user, id: 'a1')
      query = described_class.new(user_ids: [0])

      User.stub(:any_in).with(_id: [0]).and_return([user])

      Pavlov.stub(:query)
      Pavlov.stub(:query)
        .with(:'users/follower_count', graph_user_id: user.graph_user.id)
        .and_return(follower_count)
      Pavlov.stub(:query)
        .with(:'users/following_count', graph_user_id: user.graph_user.id)
        .and_return(following_count)

      expect(query.call[0].statistics[:created_fact_count]).to eq created_fact_count
      expect(query.call[0].statistics[:follower_count]).to eq follower_count
      expect(query.call[0].statistics[:following_count]).to eq following_count
    end

    it 'should work with multiple ids' do
      user_ids = [0, 1]
      graph_user0 = double(id: '10', sorted_created_facts: double(size: 10))
      graph_user1 = double(id: '20', sorted_created_facts: double(size: 10))
      user0 = double(graph_user: graph_user0, id: 'a1')
      user1 = double(graph_user: graph_user1, id: 'a2')
      query = described_class.new(user_ids: user_ids)

      User.stub(:any_in).with(_id: user_ids).and_return([user0, user1])

      Pavlov.stub(:query)

      expect(query.call.length).to eq 2
    end

    it 'can search by graph_user ids' do
      graph_user_ids = [0, 1]
      graph_user0 = double(id: '10', user_id:8080, sorted_created_facts: double(size: 10))
      graph_user1 = double(id: '20', sorted_created_facts: double(size: 10))
      user0 = double(graph_user: graph_user0, id: 'a1')
      user1 = double(graph_user: graph_user1, id: 'a2')
      query = described_class.new(user_ids: graph_user_ids, by: :graph_user_id)

      User.stub(:any_in).with(graph_user_id: graph_user_ids).and_return([user0, user1])

      Pavlov.stub(:query)

      expect(query.call.length).to eq 2
    end

  end
end
