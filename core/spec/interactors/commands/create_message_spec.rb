require File.expand_path('../../../../app/interactors/commands/create_message.rb', __FILE__)

describe Commands::CreateMessage do

  before do
    stub_const('Message', Class.new)
    stub_const('User', Class.new)
  end

  it 'initializes correctly' do
    command = Commands::CreateMessage.new 'bla', 'bla', 'bf1'
    command.should_not be_nil
  end

  it 'initialize throws error on empty message' do
    expect { Commands::CreateMessage.new 'bla', '', '1fe' }.
      to raise_error(RuntimeError, 'Message cannot be empty.')
  end

  it 'initialize throws error on too long message' do
    expect { Commands::CreateMessage.new 'bla', (0...5001).map{65.+(rand(26)).chr}.join, '1' }.
      to raise_error(RuntimeError, 'Message cannot be longer than 5000 characters.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Commands::CreateMessage.new 'bla','bla','g6'}.
      to raise_error(RuntimeError, 'conversation_id should be an hexadecimal string.')
  end

  describe '.execute' do

    it 'creates and saves a message' do
      sender = 'bla'
      content = 'bla'
      conversation_id = '1'
      command = Commands::CreateMessage.new sender, content, conversation_id
      message = double("message", {:sender= => nil,:content= => nil,:conversation_id= => nil})
      Message.should_receive(:create).and_return(message)
      User.should_receive(:where).with(username: 'bla').and_return(['user'])
      message.should_receive(:save)

      command.execute
    end
  end
end
