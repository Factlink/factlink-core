require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/top_with_authority_for_graph_user_id'

describe Queries::UserTopics::TopWithAuthorityForGraphUserId do
  include PavlovSupport

  before do
    stub_classes 'GraphUser', 'TopicsSortedByAuthority', 'Topic'
  end

  describe '#call' do
    it 'returns dead objects for the user topics based on the topics' do
      user_topics_by_authority = mock
      graph_user = mock id: "6", user_id: 'asdf'
      limit_topics = 2

      topics = [
        mock(:topic, id: "1", title: 'Bye', slug_title: 'bye'),
        mock(:topic, id: "2", title: 'Yo', slug_title: 'yo'),
      ]

      query = described_class.new graph_user_id: graph_user.id,
        limit_topics: limit_topics

      GraphUser.stub(:[])
        .with(graph_user.id)
        .and_return(graph_user)

      TopicsSortedByAuthority.stub(:new)
        .with(graph_user.user_id.to_s)
        .and_return(user_topics_by_authority)

      user_topics_by_authority.stub(:ids_and_authorities_desc_limit)
        .with(limit_topics)
        .once
        .and_return [{id: topics[1].id, authority: 20}, {id: topics[0].id, authority: 10}]

      Topic.stub(:find)
        .with(topics[0].id)
        .and_return(topics[0])

      Topic.stub(:find)
        .with(topics[1].id)
        .and_return(topics[1])

      Topic.stub(:any_in)
           .with(id: [topics[1].id, topics[0].id])
           .and_return(topics)

      user_topics = [
        DeadUserTopic.new(topics[1].slug_title, topics[1].title, 20),
        DeadUserTopic.new(topics[0].slug_title, topics[0].title, 10)
      ]

      expect(query.call).to eq user_topics
    end
  end
end
