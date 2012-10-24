require File.expand_path('../../../../app/interactors/commands/create_conversation.rb', __FILE__)

describe Commands::CreateConversation do

  let(:fact_id) {10}

  before do
    stub_const('Conversation', Class.new)
    stub_const('User', Class.new)
    stub_const('Fact', Class.new)
  end

  it 'initializes correctly' do
    command = Commands::CreateConversation.new fact_id, ['username']
    command.should_not be_nil
  end

  it 'throws an error when recipient_usernames is not a list' do
    expect { Commands::CreateConversation.new fact_id, nil }.
      to raise_error(RuntimeError, 'recipient_usernames should be a list')
  end

  it 'throws an error when recipient_usernames is an empty list' do
    expect { Commands::CreateConversation.new fact_id, [] }.
      to raise_error(RuntimeError, 'recipient_usernames should not be empty')
  end

  describe '.execute' do
    it 'should execute correctly' do
      username = 'username'
      command = Commands::CreateConversation.new fact_id, [username]
      recipients = mock('recipients')
      conversation = mock('conversation', :recipients => recipients)
      Conversation.should_receive(:new).and_return(conversation)
      user = mock()
      User.should_receive(:where).with(username: username).and_return([user])

      fact_data_id = 'abc'
      fact = mock('fact', data_id: fact_data_id)
      Fact.should_receive(:[]).with(fact_id).and_return(fact)

      recipients.should_receive(:<<).with(user)

      conversation.should_receive(:fact_data_id=).with(fact_data_id)
      conversation.should_receive(:save)

      command.execute
    end

    it 'should throw when an invalid username is given' do
      username = 'username'
      command = Commands::CreateConversation.new(fact_id, [username])
      Conversation.should_receive(:new).and_return(mock('conversation'))
      User.should_receive(:where).with(username: username).and_return([])

      expect {command.execute}.to raise_error(RuntimeError, 'Username does not exist')
    end
  end
end
