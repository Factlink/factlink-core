require File.expand_path('../../../../app/interactors/commands/create_message.rb', __FILE__)

describe Commands::CreateMessage do

  before do
    stub_const('Message', Class.new)
    stub_const('User', Class.new)
  end

  it 'initialize throws error on empty message' do
    user = stub(id: 14)
    User.stub(find: user)

    conversation = stub(repicient_ids: [14])

    expect { Commands::CreateMessage.new 14, '', conversation }.
      to raise_error(RuntimeError, 'Message cannot be empty.')
  end

  let(:long_message_string) { (0...5001).map{65.+(rand(26)).chr}.join }
  let(:content) {'bla'}

  it 'initialize throws error on too long message' do
    expect { Commands::CreateMessage.new 'bla', long_message_string , '1' }.
      to raise_error(RuntimeError, 'Message cannot be longer than 5000 characters.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    user = stub(id: 14)
    User.stub(find: user)

    conversation = stub(id: 'g6', repicient_ids: [14])

    expect { Commands::CreateMessage.new 14,'bla',conversation}.
      to raise_error(RuntimeError, 'conversation_id should be an hexadecimal string.')
  end

  describe '.execute' do
    it 'creates and saves a message' do
      conversation = stub(id: 1, recipient_ids: [14])

      sender = stub(id: 14)

      command = Commands::CreateMessage.new sender.id.to_s, content, conversation, current_user: sender
      conversation.should_receive(:save)
      message = mock()
      message.should_receive("sender_id=").with(sender.id.to_s)
      message.should_receive('content=').with(content)
      message.should_receive('conversation_id=').with(conversation.id)

      Message.should_receive(:new).and_return(message)
      message.should_receive(:save)

      expect(command.execute).to eq(nil)
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
