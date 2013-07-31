require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_message.rb'

describe Commands::CreateMessage do

  before do
    stub_const('Message', Class.new)
    stub_const('User', Class.new)
    stub_const 'Pavlov::ValidationError', Class.new(StandardError)
  end

  let(:long_message_string) { (0...5001).map{65.+(rand(26)).chr}.join }
  let(:content) {'bla'}

  describe '.validate' do
    it 'throws error on empty message' do
      user = stub(id: 14)
      User.stub(find: user)

      conversation = stub(repicient_ids: [14])

      expect { Commands::CreateMessage.new 14, '', conversation }.
        to raise_error(Pavlov::ValidationError, 'message_empty')
    end

    it 'throws error on message with just whitespace' do
      user = stub(id: 14)
      User.stub(find: user)

      conversation = stub(repicient_ids: [14])

      expect { Commands::CreateMessage.new 14, " \t\n", conversation }.
        to raise_error(Pavlov::ValidationError, 'message_empty')
    end

    it 'throws error on too long message' do
      expect { Commands::CreateMessage.new 'bla', long_message_string , '1' }.
        to raise_error(RuntimeError, 'Message cannot be longer than 5000 characters.')
    end

    it 'it throws when initialized with a argument that is not a hexadecimal string' do
      user = stub(id: 14)
      User.stub(find: user)

      conversation = stub(id: 'g6', repicient_ids: [14])

      expect { Commands::CreateMessage.new 14,'bla',conversation}.
        to raise_error(Pavlov::ValidationError, 'conversation_id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    it 'creates and saves a message' do
      conversation = stub(id: 1, recipient_ids: [14])

      sender = stub(id: 14)

      command = Commands::CreateMessage.new sender.id.to_s, content, conversation, current_user: sender
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
      conversation = stub(id: 1, recipient_ids: [14])
      sender = stub(id: 14)
      other_user = stub(id: 15)

      expect { Commands::CreateMessage.new sender.id.to_s, content, conversation, current_user: other_user }.
        to raise_error(Pavlov::AccessDenied)
    end

    it 'checks recipients' do
      conversation = stub(id: 1, recipient_ids: [15])
      sender = stub(id: 14)

      expect { Commands::CreateMessage.new sender.id.to_s, content, conversation, current_user: sender }.
        to raise_error(Pavlov::AccessDenied)
    end

    it 'authorizes if there are no problems' do
      conversation = stub(id: 1, recipient_ids: [14])
      sender = stub(id: 14)
      command = Commands::CreateMessage.new sender.id.to_s, content, conversation, current_user: sender

      expect(command.authorized?).to eq(true)
    end
  end
end
