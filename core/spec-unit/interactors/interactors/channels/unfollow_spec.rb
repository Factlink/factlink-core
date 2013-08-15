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

  describe '#call' do
    it 'removes all following channels of the current user' do
      channel = double :channel, id:'12', slug_title:'bla'

      following_channel_ids = ['14', '17']
      following_channels = [double, double]
      pavlov_options = { current_user: double(graph_user_id: double) }

      interactor = described_class.new channel_id: channel.id,
        pavlov_options: pavlov_options

      Pavlov.stub(:query)
            .with(:'channels/get',
                      id: channel.id, pavlov_options: pavlov_options)
            .and_return(channel)

      Pavlov.stub(:query)
            .with(:'containing_channel_ids_for_channel_and_user',
                      channel_id: channel.id,
                      graph_user_id: pavlov_options[:current_user].graph_user_id,
                      pavlov_options: pavlov_options)
            .and_return(following_channel_ids)


      following_channels.length.times do |i|
        Pavlov.stub(:query)
              .with(:'channels/get',
                        id: following_channel_ids[i], pavlov_options: pavlov_options)
              .and_return(following_channels[i])
        Pavlov.should_receive(:command)
              .with(:'channels/remove_subchannel',
                        channel: following_channels[i], subchannel: channel,
                        pavlov_options: pavlov_options)
      end
      interactor.execute
    end
  end
end
