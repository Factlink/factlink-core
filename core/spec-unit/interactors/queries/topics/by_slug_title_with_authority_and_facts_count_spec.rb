require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_slug_title_with_authority_and_facts_count'

describe Queries::Topics::BySlugTitleWithAuthorityAndFactsCount do
  include PavlovSupport

  describe 'validation' do
    it 'checks the slug_title' do
      slug_title = double

      query = described_class.new slug_title: 1

      expect{ query.call }.to raise_error Pavlov::ValidationError, 'slug_title should be a string.'
    end
  end
  describe '#call' do
    it 'returns the topic' do
      topic = double(slug_title: 'slug_title', title: double)
      dead_topic = double
      pavlov_options = {current_user: double}
      query = described_class.new slug_title: topic.slug_title, pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
        .with(:'topics/by_slug_title', topic.slug_title, pavlov_options)
        .and_return(topic)
      Pavlov.stub(:old_query)
        .with(:'topics/dead_topic_with_authority_and_facts_count_by_topic', topic, pavlov_options)
        .and_return(dead_topic)

      expect(query.call).to eq dead_topic
    end
  end
end
