require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/follow'

describe Interactors::Channels::Follow do
  include PavlovSupport

  describe '.authorized?' do
    it 'forbids execution without current_user' do
      expect_validating( channel_id: '10')
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    context 'a channel with the same slug_title exists' do
      it 'returns the channel with the same slug_title' do
        channel = mock :channel, id:'12', slug_title:'bla', topic: mock(id: mock)
        channel_2 = mock :channel_2, id:'38', slug_title:'bla'
        current_user = mock graph_user_id: mock
        pavlov_options = { current_user: current_user }

        interactor = described_class.new channel_id: channel.id,
          pavlov_options: pavlov_options


        interactor.should_receive(:old_query)
                  .with(:'channels/get',channel.id)
                  .and_return(channel)

        interactor.should_receive(:old_command)
                  .with(:'channels/follow', channel)
                  .and_return(channel_2)

        interactor.should_receive(:old_command)
          .with(:'channels/added_subchannel_create_activities', channel_2, channel)

        interactor.should_receive(:old_command)
                  .with(:'topics/favourite', current_user.graph_user_id, channel.topic.id.to_s)

        interactor.execute
      end
    end

    context "when adding the channel fails" do
      it "does not create activities" do
        channel = mock :channel, id:'12', slug_title:'bla', topic: mock(id: mock)
        channel_2 = mock :channel_2, id:'38', slug_title:'bla'
        current_user = mock graph_user_id: mock
        pavlov_options = { current_user: current_user }

        interactor = described_class.new channel_id: channel.id,
          pavlov_options: pavlov_options

        interactor.stub(:old_query).with(:'channels/get',channel.id).and_return(channel)

        interactor.should_receive(:old_command).once
                  .with(:'channels/follow', channel)
                  .and_return(nil)

        interactor.should_not_receive(:old_command)
                  .with(:'channels/added_subchannel_create_activities', channel_2, channel)

        interactor.should_not_receive(:old_command)
                  .with(:'topics/favourite', current_user.graph_user_id, channel.topic.id)

        interactor.execute
      end
    end
  end
end
