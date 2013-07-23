require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_subchannel'

describe Interactors::Channels::AddSubchannel do
  include PavlovSupport
  describe '.execute' do
    let(:channel) { mock :channel, id:'12' }
    let(:subchannel) { mock :subchannel, id:'45' }
    let(:options) { {ability: mock(can?: true)} }
    before do
      Pavlov.stub(:old_query) do |query_name, id|
        raise 'error' unless query_name == :'channels/get'
        if id == channel.id
          channel
        elsif id == subchannel.id
            subchannel
        else
          nil
        end
      end
    end
    it 'adds a subchannel to the channel' do
      interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:command)
                .with(:'channels/add_subchannel', channel, subchannel)
                .and_return(true)

      interactor.should_receive(:command)
             .with(:'channels/added_subchannel_create_activities', channel, subchannel)

      interactor.execute
    end
    it 'adds a subchannel to the channel, but if the command fails it does not create activity' do
      interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:command)
                .with(:'channels/add_subchannel', channel, subchannel)
                .and_return(false)

      interactor.should_not_receive(:command)
           .with(:'channels/added_subchannel_create_activities', channel, subchannel)

      interactor.execute
    end
  end
end
