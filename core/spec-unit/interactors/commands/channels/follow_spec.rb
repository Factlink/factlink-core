require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/follow'

describe Commands::Channels::Follow do
  include PavlovSupport
  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect do
        Commands::Channels::Follow.new(mock)
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '#call' do
    context 'a channel with the same slug_title exists' do
      it 'returns the channel with the same slug_title' do
        channel = mock :channel, id:'12', slug_title:'bla'
        channel_2 = mock :channel_2, id:'38', slug_title:'bla'
        options = {current_user: mock}

        command = Commands::Channels::Follow.new(channel, options)

        command.should_receive(:old_query)
                  .with(:'channels/get_by_slug_title', channel.slug_title)
                  .and_return(channel_2)

        command.should_receive(:old_command)
                  .with(:'channels/add_subchannel',
                        channel_2, channel)
                  .and_return(true)

        expect(command.execute).to eq channel_2
      end
    end
    context 'channel with matching slug_title did not exist before' do
      it 'returns newly created channel' do
        channel = mock :channel, id:'12', slug_title:'bla', title: 'Bla'
        new_channel = mock :new_channel, id:'38', slug_title:'bla'
        options = {current_user: mock}

        command = Commands::Channels::Follow.new(channel, options)

        command.should_receive(:old_query)
                  .with(:'channels/get_by_slug_title', channel.slug_title)
                  .and_return(nil)

        command.should_receive(:old_command)
                  .with(:'channels/create', channel.title)
                  .and_return(new_channel)

        command.should_receive(:old_command)
                  .with(:'channels/add_subchannel',
                        new_channel, channel)
                  .and_return(true)

        expect(command.execute).to eq new_channel
      end
    end
    context "when adding the channel fails" do
      it "returns nil" do
        channel = mock :channel, id:'12', slug_title:'bla'
        channel_2 = mock :channel_2, id:'38', slug_title:'bla'
        options = {current_user: mock}

        command = Commands::Channels::Follow.new(channel, options)

        command.should_receive(:old_query)
                  .with(:'channels/get_by_slug_title', channel.slug_title)
                  .and_return(channel_2)

        command.should_receive(:old_command)
                  .with(:'channels/add_subchannel',
                        channel_2, channel)
                  .and_return(false)

        expect(command.execute).to eq nil
      end
    end

  end

end
