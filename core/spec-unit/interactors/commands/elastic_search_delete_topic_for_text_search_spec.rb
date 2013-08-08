require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_delete_topic_for_text_search.rb'

describe Commands::ElasticSearchDeleteTopicForTextSearch do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch::Index'
  end

  it 'raises when topic is not a Topic' do
    expect { Commands::ElasticSearchDeleteTopicForTextSearch.new(object: 'Topic').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      topic = double id: 1
      index = double
      ElasticSearch::Index.stub(:new).with('topic').and_return(index)
      command = Commands::ElasticSearchDeleteTopicForTextSearch.new object: topic

      index.should_receive(:delete).with(topic.id)

      command.call
    end
  end

end
