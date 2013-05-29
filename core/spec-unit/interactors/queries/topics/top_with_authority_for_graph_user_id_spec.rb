require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/topics/top_with_authority_for_graph_user_id'

describe Queries::Topics::TopWithAuthorityForGraphUserId do
  include PavlovSupport

  before do
    stub_classes 'GraphUser', 'ChannelList', 'Topic'
  end

  describe '#call' do
    it 'returns dead objects for the user topics based on the topics' do
      graph_user = mock id: 6
      topics = [
        mock(:topic, title: 'Bye', slug_title: 'bye'),
        mock(:topic, title: 'Yo', slug_title: 'yo'),
        mock(:topic, title: 'Hi', slug_title: 'hi')
      ]

      query = described_class.new graph_user.id, 2

      Pavlov.stub(:query)
            .with(:'topics/posted_to_by_graph_user')
            .and_return(topics)

      Pavlov.stub(:query)
            .with(:'authority_on_topic_for',topics[0], graph_user)
            .and_return 2
      Pavlov.stub(:query)
            .with(:'authority_on_topic_for',topics[1], graph_user)
            .and_return 1
      Pavlov.stub(:query)
            .with(:'authority_on_topic_for',topics[2], graph_user)
            .and_return 8
      GraphUser.stub(:[]).with(graph_user.id)
               .and_return(graph_user)

      query.stub topics: topics

      user_topics = [
        DeadUserTopic.new(topics[2].slug_title, topics[2].title, 8),
        DeadUserTopic.new(topics[0].slug_title, topics[0].title, 2)
      ]
      expect(query.call).to eq user_topics
    end
  end


end
