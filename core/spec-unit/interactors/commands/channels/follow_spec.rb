require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/follow'

describe Commands::Channels::Follow do
  include PavlovSupport
  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect do
        described_class.new(channel: double, pavlov_options: { current_user: nil }).call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '#call' do
    context 'a channel with the same slug_title exists' do
      it 'returns the channel with the same slug_title' do
        channel = double :channel, id:'12', slug_title:'bla'
        channel_2 = double :channel_2, id:'38', slug_title:'bla'
        options = {current_user: double}

        command = described_class.new(channel: channel, pavlov_options: options)

        Pavlov.should_receive(:query)
              .with(:'channels/get_by_slug_title',
                        slug_title: channel.slug_title, pavlov_options: options)
              .and_return(channel_2)

        Pavlov.should_receive(:command)
              .with(:'channels/add_subchannel',
                        channel: channel_2, subchannel: channel,
                        pavlov_options: options)
              .and_return(true)

        expect(command.execute).to eq channel_2
      end
    end
    context 'channel with matching slug_title did not exist before' do
      it 'returns newly created channel' do
        channel = double :channel, id:'12', slug_title:'bla', title: 'Bla'
        new_channel = double :new_channel, id:'38', slug_title:'bla'
        options = {current_user: double}

        command = described_class.new(channel: channel, pavlov_options: options)

        Pavlov.should_receive(:query)
              .with(:'channels/get_by_slug_title',
                        slug_title: channel.slug_title, pavlov_options: options)
              .and_return(nil)

        Pavlov.should_receive(:command)
              .with(:'channels/create',
                        title: channel.title, pavlov_options: options)
              .and_return(new_channel)

        Pavlov.should_receive(:command)
              .with(:'channels/add_subchannel',
                        channel: new_channel, subchannel: channel,
                        pavlov_options: options)
              .and_return(true)

        expect(command.execute).to eq new_channel
      end
    end
    context "when adding the channel fails" do
      it "returns nil" do
        channel = double :channel, id:'12', slug_title:'bla'
        channel_2 = double :channel_2, id:'38', slug_title:'bla'
        options = {current_user: double}

        command = described_class.new(channel: channel, pavlov_options: options)

        Pavlov.should_receive(:query)
              .with(:'channels/get_by_slug_title',
                        slug_title: channel.slug_title, pavlov_options: options)
              .and_return(channel_2)

        Pavlov.should_receive(:command)
              .with(:'channels/add_subchannel',
                        channel: channel_2, subchannel: channel,
                        pavlov_options: options)
              .and_return(false)

        expect(command.execute).to eq nil
      end
    end

  end

end
