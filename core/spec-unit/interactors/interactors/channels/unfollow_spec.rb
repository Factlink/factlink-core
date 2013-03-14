require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/unfollow'

describe Interactors::Channels::Unfollow do
  include PavlovSupport
  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect do
        Interactors::Channels::Unfollow.new('10')
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    it 'removes all following channels of the current user' do
      channel = mock :channel, id:'12', slug_title:'bla'

      following_channel_ids = ['14', '17']
      following_channels = [mock, mock]
      options = {current_user: mock(graph_user_id: mock)}

      interactor = Interactors::Channels::Unfollow.new(channel.id, options)

      interactor.stub(:query).with(:'channels/get', channel.id).and_return(channel)


      interactor.stub(:query)
           .with(:containing_channel_ids_for_channel_and_user,
                 channel.id,
                 options[:current_user].graph_user_id)
           .and_return(following_channel_ids)


      following_channels.length.times do |i|
        interactor.should_receive(:query)
                  .with(:'channels/get', following_channel_ids[i])
                  .and_return(following_channels[i])
        interactor.should_receive(:command)
                  .with(:'channels/remove_subchannel',
                        following_channels[i], channel)
      end
      interactor.execute
    end
  end
end
