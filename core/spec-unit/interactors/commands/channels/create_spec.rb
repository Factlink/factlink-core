require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/create'

describe Commands::Channels::Create do
  include PavlovSupport
  describe '#call' do
    it 'creates a channel with the requested title' do
      channel = double :channel
      title = 'foobar'
      current_user = double :user, graph_user_id:15

      stub_classes('Channel')
      Channel.stub(:new).with(title:title, created_by_id:current_user.graph_user_id)
          .and_return(channel)

      channel.stub valid?:true

      command = described_class.new title: title, pavlov_options: { current_user: current_user}

      channel.should_receive(:save)

      expect(command.execute).to eq channel
    end
  end
end
