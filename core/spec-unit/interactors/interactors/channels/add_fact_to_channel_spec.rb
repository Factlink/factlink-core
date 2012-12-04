require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_fact_to_channel'

describe Interactors::Channels::AddFactToChannel do
  describe '.execute' do
    it 'correctly' do
      fact = mock
      channel = mock
      current_graph_user = mock

      Interactors::Channels::AddFactToChannel.any_instance.should_receive(:authorized?).and_return true

      interactor = Interactors::Channels::AddFactToChannel.new fact, channel

      interactor.should_receive(:current_graph_user).and_return(current_graph_user)
      interactor.should_receive(:command).with(:"channels/add_fact_to_channel", fact, channel)
      interactor.should_receive(:command).with(:"create_activity", current_graph_user, :added_fact_to_channel, fact, channel)

      interactor.execute
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      fact = mock
      channel = mock
      current_user = mock
      interactor = Interactors::Channels::AddFactToChannel.new fact, channel, current_user: current_user

      expect(interactor.authorized?).to eq current_user
    end
  end

  describe '.current_graph_user' do
    it 'should return the value of current_user.graph_user' do
      fact = mock
      channel = mock
      current_user = mock
      current_graph_user = mock

      Interactors::Channels::AddFactToChannel.any_instance.should_receive(:authorized?).and_return true

      interactor = Interactors::Channels::AddFactToChannel.new fact, channel, current_user: current_user

      current_user.should_receive(:graph_user).and_return current_graph_user

      expect(interactor.current_graph_user).to eq current_graph_user
    end
  end
end
