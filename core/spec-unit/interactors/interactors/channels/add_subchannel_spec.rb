require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_subchannel'

describe Interactors::Channels::AddSubchannel do
  include PavlovSupport
  describe '#call' do
    let(:channel) { double :channel, id:'12' }
    let(:subchannel) { double :subchannel, id:'45' }
    let(:pavlov_options) { {ability: double(can?: true)} }
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
      interactor = described_class.new channel_id: channel.id,
        subchannel_id: subchannel.id, pavlov_options: pavlov_options

      Pavlov.should_receive(:old_command)
                .with(:'channels/add_subchannel', channel, subchannel, pavlov_options)
                .and_return(true)

      Pavlov.should_receive(:old_command)
             .with(:'channels/added_subchannel_create_activities', channel, subchannel, pavlov_options)

      interactor.execute
    end
    it 'adds a subchannel to the channel, but if the command fails it does not create activity' do
      interactor = described_class.new channel_id: channel.id,
        subchannel_id: subchannel.id, pavlov_options: pavlov_options
      Pavlov.should_receive(:old_command)
                .with(:'channels/add_subchannel', channel, subchannel, pavlov_options)
                .and_return(false)

      Pavlov.should_not_receive(:old_command)
           .with(:'channels/added_subchannel_create_activities', channel, subchannel, pavlov_options)

      interactor.execute
    end
  end
end
