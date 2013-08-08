require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_delete_topic_for_text_search.rb'

describe Commands::ElasticSearchDeleteTopicForTextSearch do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  it 'raises when topic is not a Topic' do
    expect { Commands::ElasticSearchDeleteTopicForTextSearch.new('Topic').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      topic = double id: 1
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/topic/#{topic.id}")
      command = Commands::ElasticSearchDeleteTopicForTextSearch.new topic

      command.call
    end
  end

end
