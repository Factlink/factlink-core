require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_delete_topic_for_text_search.rb'

describe Commands::ElasticSearchDeleteTopicForTextSearch do
  include PavlovSupport

  let(:topic) do
    topic = stub()
    topic.stub id: 1
    topic
  end

  before do
    stub_const('HTTParty', Class.new)
    stub_const('FactlinkUI::Application', Class.new)
  end

  it 'intitializes' do
    interactor = Commands::ElasticSearchDeleteTopicForTextSearch.new topic

    interactor.should_not be_nil
  end

  it 'raises when topic is not a Topic' do
    expect { Commands::ElasticSearchDeleteTopicForTextSearch.new 'Topic' }.
      to raise_error(RuntimeError, 'topic missing fields ([:id]).')
  end

  describe '.call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/topic/#{topic.id}")
      interactor = Commands::ElasticSearchDeleteTopicForTextSearch.new topic

      interactor.call
    end
  end

end
