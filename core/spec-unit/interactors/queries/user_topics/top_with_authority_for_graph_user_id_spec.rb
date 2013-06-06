require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/top_with_authority_for_graph_user_id'

describe Queries::UserTopics::TopWithAuthorityForGraphUserId do
  include PavlovSupport

  before do
    stub_classes 'GraphUser', 'UserTopicsByAuthority', 'Topic'
  end

  describe '#call' do
    it 'returns dead objects for the user topics based on the topics' do
      user_topics_by_authority = mock
      graph_user = mock id: 6, user_id: 'asdf'
      limit_topics = 2

      topics = [
        mock(:topic, title: 'Bye', slug_title: 'bye'),
        mock(:topic, title: 'Yo', slug_title: 'yo'),
      ]

      query = described_class.new graph_user.id, limit_topics

      GraphUser.stub(:[]).
        with(graph_user.id).
        and_return(graph_user)

      UserTopicsByAuthority.stub(:new).
        with(graph_user.user_id.to_s).
        and_return(user_topics_by_authority)

      user_topics_by_authority.stub(:ids_and_authorities_desc_limit).
        with(limit_topics).
        and_return [{id: "2", authority: 20}, {id: "1", authority: 10}]

      Topic.stub(:find).
        with("1").
        and_return(topics[0])

      Topic.stub(:find).
        with("2").
        and_return(topics[1])

      user_topics = [
        DeadUserTopic.new(topics[1].slug_title, topics[1].title, 20),
        DeadUserTopic.new(topics[0].slug_title, topics[0].title, 10)
      ]

      expect(query.call).to eq user_topics
    end
  end


end
