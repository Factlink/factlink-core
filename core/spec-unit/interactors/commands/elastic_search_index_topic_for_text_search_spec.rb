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

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/topic/#{topic.id}"
      command = described_class.new(object: topic)

      hashie = {}
      json_document = double
      Commands::ElasticSearchIndexForTextSearch.any_instance.stub(:document).and_return(hashie)
      hashie.stub(:to_json).and_return(json_document)

      HTTParty.should_receive(:put).with(url, { body: json_document })

      command.call
    end
  end
end
