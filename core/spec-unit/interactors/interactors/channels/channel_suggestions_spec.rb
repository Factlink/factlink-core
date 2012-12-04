require "pavlov_helper"
require_relative "../../../../app/interactors/interactors/channels/channel_suggestions.rb"

describe Interactors::Channels::ChannelSuggestions do
  describe '.execute' do
    before do
      stub_const('Queries', Class.new)
      stub_const('Queries::Channels', Class.new)
      stub_const('Queries::Channels::ChannelSuggestions', Class.new)
    end

    it 'should call the channel_suggestions query and return the returned value' do
      current_user = mock
      query = mock
      result = mock

      Interactors::Channels::ChannelSuggestions.any_instance.stub(authorized?: true)

      interactor = Interactors::Channels::ChannelSuggestions.new current_user: current_user

      Queries::Channels::ChannelSuggestions.should_receive(:new).and_return(query)
      query.should_receive(:execute).and_return result

      expect(interactor.execute).to eq result
    end
  end

  describe '.authorized?' do
    it 'should return the passed current_user' do
      current_user = mock

      interactor = Interactors::Channels::ChannelSuggestions.new current_user: current_user

      expect(interactor.authorized?).to eq current_user
    end
  end
end
