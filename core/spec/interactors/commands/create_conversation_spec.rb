require File.expand_path('../../../../app/interactors/commands/create_conversation.rb', __FILE__)

describe Commands::CreateConversation do

  before do
    stub_const('Conversation', Class.new)
    stub_const('User', Class.new)
  end

  it 'initializes correctly' do
    command = Commands::CreateConversation.new ['username']
    command.should_not be_nil
  end

  it 'throws an error when recipient_usernames is not a list' do
    expect { Commands::CreateConversation.new nil }.
      to raise_error(RuntimeError, 'recipient_usernames should be a list')
  end

  it 'throws an error when recipient_usernames is an empty list' do
    expect { Commands::CreateConversation.new [] }.
      to raise_error(RuntimeError, 'recipient_usernames should not be empty')
  end

  describe '.execute' do
    it 'correctly' do
      username = 'username'
      command = Commands::CreateConversation.new [username]
      conversation = mock('conversation', :recipients => [])
      Conversation.should_receive(:new).and_return(conversation)
      user = mock()
      User.should_receive(:where).with(username: username).and_return([user])
      conversation.should_receive(:save)

      command.execute
    end
  end
end
