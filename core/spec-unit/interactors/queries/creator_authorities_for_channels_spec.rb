require 'pavlov_helper'
require_relative '../../../app/interactors/queries/creator_authorities_for_channels.rb'

describe Queries::CreatorAuthoritiesForChannels do
  include PavlovSupport

  before do
    stub_classes 'GraphUser'
  end

  describe '#query' do
    it 'should retrieve the authority for each channel and return this in a list' do
      channels = [double, double]
      channel_authorities = [double,double]
      query = described_class.new channels: channels

      0.upto(1) do |i|
        query.stub(:authority_for).with(channels[i])
            .and_return(channel_authorities[i])
      end

      expect(query.call).to eq channel_authorities
    end
  end

  describe '#authority_for' do
    it 'should retrieve the topic, and retrieve the authority for the topic' do
      channel_creator = double(:some_graph_user)
      channel = double('channel', created_by: channel_creator)
      topic = double
      topic_authority = double
      query = described_class.new channels: double

      query.stub(:topic_for).with(channel)
           .and_return(topic)
      query.stub(:graph_user_for).with(channel)
           .and_return(channel_creator)
      Pavlov.stub(:query)
            .with(:'authority_on_topic_for',
                      topic: topic, graph_user: channel_creator)
            .and_return(topic_authority)

      result = query.authority_for(channel)

      expect(result).to eq topic_authority
    end

    it 'should raise when the channel is not a real channel.' do
      channel_creator = double(:some_graph_user)
      channel = double('channel', created_by: channel_creator)
      query = described_class.new channels: double

      expect do
        query.authority_for(channel)
      end.to raise_error
    end
  end

  describe '#graph_user_for' do
    it 'should return the created_by user' do
      channel_creator = double(:some_graph_user, id: 256)
      channel = double('channel',
                  created_by: channel_creator,
                  created_by_id: channel_creator.id)
      query = described_class.new channels: [channel]

      channel.stub(:write_local).with(:created_by, channel_creator)
      GraphUser.stub(:[]).with(256).and_return(channel_creator)

      expect(query.graph_user_for(channel)).to eq(channel_creator)
    end

    it 'should only retrieve the user once' do
      channel_creator = double(:some_graph_user, id: 256)
      channel = double('channel', created_by_id: channel_creator.id)
      channel2 = double('channel', created_by_id: channel_creator.id)
      query = described_class.new channels: [channel]

      channel.stub(:write_local).with(:created_by, channel_creator)
      channel2.stub(:write_local).with(:created_by, channel_creator)
      GraphUser.should_receive(:[]).with(256)
               .once.and_return(channel_creator)

      expect(query.graph_user_for(channel)).to eq(channel_creator)
      expect(query.graph_user_for(channel2)).to eq(channel_creator)
    end
  end

  describe '#topic_for' do
    it 'should retrieve the topic for the channel, and return it' do
      channel = double(:channel, slug_title: 'double')
      topic = double(:topic, slug_title: 'double')
      query = described_class.new channels: [channel]

      query.stub topics: [topic]

      result = query.topic_for(channel)

      expect(result).to eq topic
    end

    it 'should find the topic with the same slug_title as the channel, and return that one' do
      channel = double(:channel, slug_title: 'channel_slug')
      channel_topic = double(:topic, slug_title: 'channel_slug')
      topics = [
        double('topic', slug_title: 'some_slug'),
        double('topic', slug_title: 'some_other_slug'),
        channel_topic,
        double('topic', slug_title: 'another_slug')
      ]
      query = described_class.new channels: [channel]

      query.stub topics: topics

      result = query.topic_for(channel)

      expect(result).to eq channel_topic
    end
  end

  describe '#topics' do
    it "should retrieve the topics for all the channels" do
      channels = double
      topics = double
      query = described_class.new channels: channels

      Pavlov.stub(:query)
            .with(:'topics_for_channels',
                      channels: channels)
            .and_return(topics)

      expect(query.topics).to eq topics
    end

    it 'should retrieve the topics once when invoked multiple times' do
      channels = double
      topics = double
      query = described_class.new channels: channels

      Pavlov.should_receive(:query)
            .with(:'topics_for_channels',
                      channels: channels)
            .once.and_return(topics)

      expect(query.topics).to eq topics
      expect(query.topics).to eq topics
    end
  end
end
