require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_message.rb'

describe Commands::CreateMessage do
  include PavlovSupport

  before do
    stub_classes 'Message', 'User'
  end

  let(:content) { 'bla' }

  describe '#call' do
    it 'creates and saves a message' do
      conversation = double(id: 1, recipient_ids: [14])

      sender = double(id: 14)

      pavlov_options = { current_user: sender }
      command = described_class.new sender_id: sender.id.to_s,
        content: content, conversation: conversation, pavlov_options: pavlov_options
      conversation.should_receive(:save)

      message = double
      message.should_receive("sender_id=").with(sender.id.to_s)
      message.should_receive('content=').with(content)
      message.should_receive('conversation_id=').with(conversation.id)

      Message.should_receive(:new).and_return(message)
      message.should_receive(:save)

      expect(command.call).to eq(message)
    end
  end

  describe '.authorized?' do
    it 'checks current_user' do
      conversation = double(id: 1, recipient_ids: [14])
      sender = double(id: 14)
      other_user = double(id: 15)

      pavlov_options = { current_user: other_user }
      command = described_class.new(sender_id: sender.id.to_s,
        content: content, conversation: conversation, pavlov_options: pavlov_options)
      expect do
        command.call
      end.to raise_error(Pavlov::AccessDenied)
    end

    it 'checks recipients' do
      conversation = double(id: 1, recipient_ids: [15])
      sender = double(id: 14)

      pavlov_options = { current_user: sender }
      command = described_class.new(sender_id: sender.id.to_s,
        content: content, conversation: conversation, pavlov_options: pavlov_options)

      expect do
        command.call
      end.to raise_error(Pavlov::AccessDenied)
    end

    it 'authorizes if there are no problems' do
      conversation = double(id: 1, recipient_ids: [14])
      sender = double(id: 14)

      pavlov_options = { current_user: sender }
      command = described_class.new(sender_id: sender.id.to_s,
        content: content, conversation: conversation, pavlov_options: pavlov_options )

      expect(command.authorized?).to eq(true)
    end
  end
end
