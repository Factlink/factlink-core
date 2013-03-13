require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/follow'

describe Interactors::Channels::Follow do
  include PavlovSupport
  before do
    stub_classes 'Channel'
  end

  describe '.execute' do
    context 'a channel with the same slug_title exists' do
      it 'returns the channel with the same slug_title' do
        channel = mock :channel, id:12, slug_title:'bla'
        channel_2 = mock :channel_2, id:38, slug_title:'bla'

        interactor = Interactors::Channels::Follow.new(channel.id)

        Channel.stub(:[]).with(channel.id).and_return(channel)

        interactor.should_receive(:query)
                  .with(:'channels/get_by_slug_title', channel.slug_title)
                  .and_return(channel_2)


        interactor.should_receive(:command)
                  .with(:'channels/add_subchannel',
                        channel_2, channel)

        interactor.execute
      end
    end


    context 'channel with matching slug_title did not exist before' do
      it 'returns newly created channel' do
        channel = mock :channel, id:12, title:'Bla', slug_title:'bla'
        new_channel = mock :new_channel, id:38, title:'Bla', slug_title:'bla'

        interactor = Interactors::Channels::Follow.new(channel.id)

        Channel.stub(:[]).with(channel.id).and_return(channel)

        interactor.should_receive(:query)
                  .with(:'channels/get_by_slug_title', channel.slug_title)
                  .and_return(nil)

        interactor.should_receive(:command)
                  .with(:'channels/create', channel.title)
                  .and_return(new_channel)

        interactor.should_receive(:command)
                  .with(:'channels/add_subchannel',
                        new_channel, channel)

        interactor.execute
      end
    end
  end
end
