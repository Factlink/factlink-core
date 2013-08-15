require 'spec_helper'

describe 'top user topics per user' do
  include PavlovSupport

  let(:user)   { create :user }

  context 'user initially' do
    it 'has no top topics' do
      as(user) do |pavlov|
        results = pavlov.query(:'user_topics/top_with_authority_for_graph_user_id', graph_user_id: user.graph_user_id, limit_topics: 10)
        expect(results).to eq []
      end
    end
  end

  context 'after creating some topics' do
    it 'has no top topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Foo')
        topic2 = pavlov.command(:'topics/create', title: 'Bar')

        results = pavlov.query(:'user_topics/top_with_authority_for_graph_user_id', graph_user_id: user.graph_user_id, limit_topics: 10)
        expect(results).to eq []
      end
    end
  end

  context 'after getting authority on some topics' do
    it 'has those as top topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Foo')
        topic2 = pavlov.command(:'topics/create', title: 'Bar')

        pavlov.command(:'topics/update_user_authority', graph_user_id: user.graph_user_id, topic_slug: 'foo', authority: 10)
        pavlov.command(:'topics/update_user_authority', graph_user_id: user.graph_user_id, topic_slug: 'bar', authority: 1)

        results = pavlov.query(:'user_topics/top_with_authority_for_graph_user_id', graph_user_id: user.graph_user_id, limit_topics: 10)

        expected_results = [
          DeadUserTopic.new('foo', 'Foo', 11),
          DeadUserTopic.new('bar', 'Bar', 2)
        ]

        expect(results).to match_array expected_results
      end
    end
  end
end
