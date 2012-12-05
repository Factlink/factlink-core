require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_fact_to_channel'

describe Interactors::Channels::AddFactToChannel do
  describe '.execute' do
    it 'correctly' do
      fact = mock
      channel = mock
      user = mock

      Interactors::Channels::AddFactToChannel.any_instance.should_receive(:authorized?).and_return true

      interactor = Interactors::Channels::AddFactToChannel.new fact, channel

      channel.should_receive(:created_by).and_return(user)

      interactor.should_receive(:command).with(:"channels/add_fact_to_channel", fact, channel)
      interactor.should_receive(:command).with(:"create_activity", user, :added_fact_to_channel, fact, channel)

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
end
