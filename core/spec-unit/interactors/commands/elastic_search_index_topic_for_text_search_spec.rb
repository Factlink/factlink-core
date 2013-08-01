require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_topic_for_text_search.rb'

describe Commands::ElasticSearchIndexTopicForTextSearch do
  include PavlovSupport

  let(:topic) do
    double(id: 1, title: 'title', slug_title: 'slug title')
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe 'validations' do
    it 'raises when topic is not a Topic' do
      command = described_class.new 'Topic'

      expect { command.call }
        .to raise_error(RuntimeError, 'topic missing fields ([:title, :slug_title, :id]).')
    end
  end

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/topic/#{topic.id}"
      command = described_class.new topic

      hashie = {}
      json_document = double
      command.stub(:document).and_return(hashie)
      hashie.stub(:to_json).and_return(json_document)

      HTTParty.should_receive(:put).with(url, { body: json_document })

      command.call
    end
  end
end
