require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_topic_for_text_search.rb'

describe Commands::ElasticSearchIndexTopicForTextSearch do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      topic = double
      command = described_class.new(topic: topic)

      Pavlov.should_receive(:old_command)
            .with :elastic_search_index_for_text_search,
                    topic,
                    :topic,
                    [:title, :slug_title]

      command.call
    end
  end
end
