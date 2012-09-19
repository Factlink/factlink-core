require File.expand_path('../../../app/interactors/index_topic_for_text_search.rb', __FILE__)
require 'json'

describe 'IndexTopicForTextSearch' do
  let(:fake_class) { Class.new }

  before do
    stub_const('Topic', fake_class)
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    topic = Topic.new
    interactor = IndexTopicForTextSearch.new topic

    interactor.should_not be_nil
  end

  it 'raises when topic is not an Topic' do
    expect { interactor = IndexTopicForTextSearch.new 'Topic' }.
      to raise_error(RuntimeError, 'Topic should be of class Topic.')
  end

  describe 'execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      topic = Topic.new
      topic.stub id: 1
      topic.stub title: 'title'
      topic.stub slug_title: 'slug'
      HTTParty.should_receive(:put).with("http://#{url}/topic/#{topic.id}",
        { body: { title: topic.title, slug_title: topic.slug_title}.to_json})
      interactor = IndexTopicForTextSearch.new topic

      interactor.execute
    end
  end
end
