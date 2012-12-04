require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/channel_suggestions'

describe Queries::Channels::ChannelSuggestions do
  include PavlovSupport

  describe '.execute' do
    it 'returns the three channels on which the current_user has the highest authority' do
      current_graph_user = mock
      channels = mock
      suggestion_count = mock

      query = Queries::Channels::ChannelSuggestions.new

      current_graph_user.should_receive(:editable_channels_by_authority)
                        .with(suggestion_count)
                        .and_return(channels)

      query.should_receive(:suggestion_count).and_return suggestion_count
      query.should_receive(:current_graph_user).and_return current_graph_user

      expect(query.execute).to eq channels
    end
  end

  describe '.current_graph_user' do
    it 'returns the .graph_user value of the passed current_user' do
      current_user = mock
      current_graph_user = mock

      query = Queries::Channels::ChannelSuggestions.new current_user: current_user

      current_user.should_receive(:graph_user).and_return current_graph_user

      expect(query.current_graph_user).to eq current_graph_user
    end
  end
end
