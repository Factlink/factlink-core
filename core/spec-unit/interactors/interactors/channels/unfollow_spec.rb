require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/unfollow'

describe Interactors::Channels::Unfollow do
  include PavlovSupport
  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect_validating( channel_id: '10')
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    it 'removes all following channels of the current user' do
      channel = mock :channel, id:'12', slug_title:'bla'

      following_channel_ids = ['14', '17']
      following_channels = [mock, mock]
      pavlov_options = { current_user: mock(graph_user_id: mock) }

      interactor = described_class.new channel_id: channel.id,
        pavlov_options: pavlov_options

      interactor.stub(:old_query).with(:'channels/get', channel.id).and_return(channel)

      interactor.stub(:old_query)
           .with(:containing_channel_ids_for_channel_and_user,
                 channel.id,
                 pavlov_options[:current_user].graph_user_id)
           .and_return(following_channel_ids)


      following_channels.length.times do |i|
        interactor.should_receive(:old_query)
                  .with(:'channels/get', following_channel_ids[i])
                  .and_return(following_channels[i])
        interactor.should_receive(:old_command)
                  .with(:'channels/remove_subchannel',
                        following_channels[i], channel)
      end
      interactor.execute
    end
  end
end
