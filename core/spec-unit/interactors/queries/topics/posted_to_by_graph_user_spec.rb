require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/posted_to_by_graph_user'

describe Queries::Topics::PostedToByGraphUser do
  include PavlovSupport

  before do
    stub_classes 'GraphUser', 'ChannelList', 'Topic'
  end

  describe '#call' do
    it 'returns the topics this graph_user posted to' do
      graph_user = mock
      channels = [
        mock(:channel, slug_title: 'food'),
        mock(:channel, slug_title: 'programming')
      ]
      channel_list = mock real_channels_as_array: channels
      topics = [mock, mock]

      query = described_class.new graph_user: graph_user

      ChannelList.stub(:new).with(graph_user)
                 .and_return(channel_list)

      Pavlov.stub(:old_query)
            .with(:'topics/by_slug_title', channels[0].slug_title)
            .and_return(topics[0])
      Pavlov.stub(:old_query)
            .with(:'topics/by_slug_title', channels[1].slug_title)
            .and_return(topics[1])

      expect(query.call).to match_array topics
    end
  end

end
