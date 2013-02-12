require_relative '../../../../app/interactors/queries/channels/handpicked'
require 'pavlov_helper'

describe Queries::Channels::Handpicked do
  include PavlovSupport

  before do
    Queries::Channels::Handpicked.any_instance.stub(:authorized?).and_return(true)
    stub_classes 'TopChannels'
  end

  describe '.execute' do
    it 'should return the non_dead_handpicked_channels' do
      channels = mock
      TopChannels.should_receive(:new).and_return (stub members: channels)


      query = Queries::Channels::Handpicked.new {}

      expect(query.execute).to eq channels
    end
  end

end
