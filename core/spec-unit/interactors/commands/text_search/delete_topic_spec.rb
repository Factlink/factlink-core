require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/delete_topic.rb'

describe Commands::TextSearch::DeleteTopic do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch::Index'
  end

  it 'raises when topic is not a Topic' do
    expect { described_class.new(object: 'Topic').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      topic = double id: 1
      index = double
      ElasticSearch::Index.stub(:new).with('topic').and_return(index)
      command = described_class.new object: topic

      index.should_receive(:delete).with(topic.id)

      command.call
    end
  end

end
