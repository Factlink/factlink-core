require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_slug_title_with_authority_and_facts_count'

describe Queries::Topics::BySlugTitleWithAuthorityAndFactsCount do
  include PavlovSupport

  describe '#validate' do
    it 'calls the correct validation methods' do
      slug_title = double

      described_class.any_instance.should_receive(:validate_string)
        .with(:slug_title, slug_title)

      interactor = described_class.new slug_title
    end
  end

  describe '#call' do
    it 'returns the topic' do
      topic = mock(slug_title: 'slug_title', title: mock)
      dead_topic = double
      pavlov_options = {current_user: mock}

      Pavlov.stub(:old_query)
        .with(:'topics/by_slug_title', topic.slug_title, pavlov_options)
        .and_return(topic)

      Pavlov.stub(:old_query)
        .with(:'topics/dead_topic_with_authority_and_facts_count_by_topic', topic, pavlov_options)
        .and_return(dead_topic)

      query = described_class.new topic.slug_title, pavlov_options

      expect(query.call).to eq dead_topic
    end
  end
end
