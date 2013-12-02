require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/top_with_authority_for_user'

describe Queries::UserTopics::TopWithAuthorityForUser do
  include PavlovSupport

  before do
    stub_classes 'GraphUser', 'TopicsSortedByAuthority', 'Topic'
  end

  describe '#call' do
    it 'returns dead objects for the user topics based on the topics' do
      user_topics_by_authority = double
      limit_topics = 2
      user_id = 'a1'

      topics = [
        double(:topic, id: "1", title: 'Bye', slug_title: 'bye'),
        double(:topic, id: "2", title: 'Yo',  slug_title: 'yo'),
      ]

      query = described_class.new user_id: user_id,
                                  limit_topics: limit_topics

      TopicsSortedByAuthority.stub(:new)
        .with(user_id.to_s)
        .and_return(user_topics_by_authority)

      user_topics_by_authority.stub(:ids_and_authorities_desc_limit)
        .with(limit_topics)
        .once
        .and_return [
          {id: topics[1].id, authority: 20},
          {id: topics[0].id, authority: 10},
        ]

      Topic.stub(:any_in)
           .with(id: [topics[1].id, topics[0].id])
           .and_return(topics)
      Topic.stub(:any_in)
           .with(id: [])
           .and_return([])

      user_topics = [
        DeadUserTopic.new(topics[1].slug_title, topics[1].title, 20),
        DeadUserTopic.new(topics[0].slug_title, topics[0].title, 10)
      ]

      expect(query.call).to eq [] # user_topics
    end
  end
end
