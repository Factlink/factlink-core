require_relative '../../../../app/interactors/interactors/channels/top'
require 'pavlov_helper'

describe Interactors::Channels::Top do
  include PavlovSupport

  before do
    Interactors::Channels::Top.any_instance.stub(:authorized?).and_return(true)
  end

  describe '.get_alive_channels' do
    it 'takes a sample of "count" handpicked channels' do
      handpicked_channels = mock
      random_channels = mock
      count = mock

      interactor = Interactors::Channels::Top.new count, {}
      interactor.should_receive(:query).with(:"channels/handpicked").and_return(handpicked_channels)

      handpicked_channels.should_receive(:sample).with(count).and_return(random_channels)

      expect(interactor.get_alive_channels).to eq random_channels
    end
  end
end
