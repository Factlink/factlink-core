require File.expand_path('../../../app/interactors/create_conversation_with_message_interactor.rb', __FILE__)

describe CreateConversationWithMessageInteractor do

  before do
    stub_const('Commands::CreateConversation',Class.new)
    stub_const('Commands::CreateMessage', Class.new)
    stub_const('Commands::CreateActivity', Class.new)
    stub_const('User', Class.new)
  end

  describe '.execute' do
    it 'correctly' do
      graph_user = mock();
      sender = mock( :user, username: 'jan', graph_user: graph_user)
      receiver = mock( :user, username: 'frank')
      content = 'geert'
      usernames = [sender.username, receiver.username]
      conversation = mock()
      should_receive_new_with_and_receive_execute(Commands::CreateConversation, usernames,current_user: sender).and_return(conversation)
      should_receive_new_with_and_receive_execute(Commands::CreateMessage, sender.username, content, conversation, current_user: sender)
      User.should_receive(:where).with(username: sender.username).and_return([sender])
      should_receive_new_with_and_receive_execute(Commands::CreateActivity, graph_user, :created_conversation, conversation, current_user: sender)

      CreateConversationWithMessageInteractor.perform usernames, sender.username, content, current_user:sender
    end
  end

  def should_receive_new_with_and_receive_execute(klass, *arguments)
    klass_instance = mock()
    klass.should_receive(:new).with(*arguments).and_return(klass_instance)
    klass_instance.should_receive(:execute)
  end
end
