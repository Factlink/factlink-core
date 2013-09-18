require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/dead_topic_with_statistics_by_topic'

describe Queries::Topics::DeadTopicWithStatisticsByTopic do
  include PavlovSupport

  describe '#call' do
    let(:topic) { double(slug_title: double, title: double, id: '1a')}

    before do
      stub_classes 'DeadTopic'
      DeadTopic.stub(:new)
    end

    it 'calls the correct validation methods' do
      query = described_class.new alive_topic: nil

      expect{ query.call }.to raise_error(Pavlov::ValidationError, 'alive_topic should not be nil.')
    end

    it 'returns the topic' do
      facts_count = 100
      current_user_authority = 200
      favouritours_count = 300
      current_user = double(graph_user: double)
      dead_topic = double
      pavlov_options = {current_user: current_user}

      Pavlov.stub(:query)
            .with(:'topics/facts_count',
                      slug_title: topic.slug_title, pavlov_options: pavlov_options)
            .and_return(facts_count)

      Pavlov.stub(:query)
            .with(:'authority_on_topic_for',
                      topic: topic, graph_user: current_user.graph_user,
                      pavlov_options: pavlov_options)
            .and_return(current_user_authority)

      Pavlov.stub(:query)
            .with(:'topics/favouritours_count',
                      topic_id: topic.id, pavlov_options: pavlov_options)
            .and_return(favouritours_count)

      DeadTopic.stub(:new)
        .with(topic.slug_title, topic.title, current_user_authority, facts_count, favouritours_count)
        .and_return(dead_topic)

      query = described_class.new alive_topic: topic, pavlov_options: pavlov_options

      expect(query.call).to eq dead_topic
    end
  end
end
