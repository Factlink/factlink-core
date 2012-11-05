require 'pavlov_helper'
require File.expand_path('../../../../app/interactors/commands/elastic_search_index_topic_for_text_search.rb', __FILE__)
require 'json'

describe Commands::ElasticSearchIndexTopicForTextSearch do
  include PavlovSupport
  
  def fake_class
    Class.new
  end

  let(:topic) do
    topic = stub()
    topic.stub id: 1,
               title: 'title',
               slug_title: 'slug title'
    topic
  end

  before do
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    interactor = Commands::ElasticSearchIndexTopicForTextSearch.new topic

    interactor.should_not be_nil
  end

  it 'raises when topic is not a Topic' do
    expect { interactor = Commands::ElasticSearchIndexTopicForTextSearch.new 'Topic' }.
      to raise_error(RuntimeError, 'topic missing fields ([:title, :slug_title, :id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/topic/#{topic.id}"
      HTTParty.should_receive(:put).with(url,
        { body: { title: topic.title, slug_title: topic.slug_title}.to_json})
      interactor = Commands::ElasticSearchIndexTopicForTextSearch.new topic

      interactor.execute
    end
  end
end
