require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/remove_subchannel'

describe Interactors::Channels::RemoveSubchannel do
  include PavlovSupport
  describe '.execute' do
    let(:channel){ mock :channel, id:'12', created_by: mock }
    let(:subchannel){ mock :subchannel, id:'45' }

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
    it 'removes a subchannel from the channel' do
      options = {ability: mock(can?: true)}

      interactor = Interactors::Channels::RemoveSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:old_command)
                .with(:'channels/remove_subchannel', channel, subchannel)
                .and_return(true)

      channel.should_receive(:activity)
             .with(channel.created_by,
                   :removed, subchannel,
                   :to, channel)

      interactor.execute
    end
    it "does not create an activity when removing the subchannel fails" do
      options = {ability: mock(can?: true)}

      interactor = Interactors::Channels::RemoveSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:old_command)
                .with(:'channels/remove_subchannel', channel, subchannel)
                .and_return(false)

      channel.should_not_receive(:activity)

      interactor.execute
    end
  end
end
