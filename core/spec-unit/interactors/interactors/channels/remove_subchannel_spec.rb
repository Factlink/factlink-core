require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/remove_subchannel'

describe Interactors::Channels::RemoveSubchannel do
  include PavlovSupport
  describe '.execute' do
    it 'removes a subchannel from the channel' do
      channel = mock :channel, id:'12'
      subchannel = mock :subchannel, id:'45'

      Pavlov.stub(:query) do |query_name, id|
        raise 'error' unless query_name == :'channels/get'
        if id == channel.id
          channel
        elsif id == subchannel.id
            subchannel
        else
          nil
        end
      end

      options = {ability: mock(can?: true)}

      interactor = Interactors::Channels::RemoveSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:command).with(:'channels/remove_subchannel', channel, subchannel)

      interactor.execute
    end
  end
end
