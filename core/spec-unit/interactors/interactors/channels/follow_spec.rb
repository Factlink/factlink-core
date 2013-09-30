require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/follow'

describe Interactors::Channels::Follow do
  include PavlovSupport

  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect do
        interactor = described_class.new(channel_id: '10')
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    context 'a channel with the same slug_title exists' do
      it 'returns the channel with the same slug_title' do
        channel = double :channel, id:'12', slug_title:'bla', topic: double(id: double)
        channel_2 = double :channel_2, id:'38', slug_title:'bla'
        current_user = double graph_user_id: double
        pavlov_options = { current_user: current_user }

        interactor = described_class.new channel_id: channel.id,
          pavlov_options: pavlov_options


        Pavlov.should_receive(:query)
              .with(:'channels/get',
                        id: channel.id, pavlov_options: pavlov_options)
              .and_return(channel)

        Pavlov.should_receive(:command)
              .with(:'channels/follow',
                        channel: channel, pavlov_options: pavlov_options)
              .and_return(channel_2)

        Pavlov.should_receive(:command)
              .with(:'channels/added_subchannel_create_activities',
                        channel: channel_2, subchannel: channel,
                        pavlov_options: pavlov_options)

        Pavlov.should_receive(:command)
              .with(:'topics/favourite',
                        graph_user_id: current_user.graph_user_id,
                        topic_id: channel.topic.id.to_s,
                        pavlov_options: pavlov_options)

        interactor.execute
      end
    end

    context "when adding the channel fails" do
      it "does not create activities" do
        channel = double :channel, id:'12', slug_title:'bla', topic: double(id: double)
        channel_2 = double :channel_2, id:'38', slug_title:'bla'
        current_user = double graph_user_id: double
        pavlov_options = { current_user: current_user }

        interactor = described_class.new channel_id: channel.id,
          pavlov_options: pavlov_options

        Pavlov.stub(:query)
              .with(:'channels/get',
                        id: channel.id, pavlov_options: pavlov_options)
              .and_return(channel)


        Pavlov.should_receive(:command)
              .with(:'channels/follow',
                        channel: channel, pavlov_options: pavlov_options)
              .once.and_return(nil)

        Pavlov.should_not_receive(:command)
              .with(:'channels/added_subchannel_create_activities',
                        channel: channel_2, subchannel: channel,
                        pavlov_options: pavlov_options)

        Pavlov.should_not_receive(:command)
              .with(:'topics/favourite',
                        graph_user_id: current_user.graph_user_id,
                        topic_id: channel.topic.id, pavlov_options: pavlov_options)

        interactor.execute
      end
    end
  end
end
