require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_topic_for_text_search.rb'

describe Commands::ElasticSearchIndexTopicForTextSearch do
  include PavlovSupport

  let(:topic) do
    topic = stub()
    topic.stub id: 1,
               title: 'title',
               slug_title: 'slug title'
    topic
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe '.new' do
    it 'returns a new non nil instance' do
      interactor = described_class.new topic

      interactor.should_not be_nil
    end

    it 'raises when topic is not a Topic' do
      expect { interactor = described_class.new 'Topic' }.
        to raise_error(RuntimeError, 'topic missing fields ([:title, :slug_title, :id]).')
    end
  end

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/topic/#{topic.id}"
      interactor = described_class.new topic
      json_document = mock

      interactor.should_receive(:json_document).and_return(json_document)
      HTTParty.should_receive(:put).with(url,
        { body: json_document})

      interactor.call
    end
  end
end
