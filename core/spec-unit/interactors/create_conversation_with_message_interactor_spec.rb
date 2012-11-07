require 'pavlov_helper'
require File.expand_path('../../../app/interactors/create_conversation_with_message_interactor.rb', __FILE__)

describe CreateConversationWithMessageInteractor do
  include PavlovSupport

  before do
    stub_classes'Commands::CreateConversation', 'Commands::CreateMessage',
                'Commands::CreateActivity', 'User'
  end

  describe '.execute' do
    it 'should call the right commands' do
      graph_user   = mock();
      sender       = mock(:user, id: 13, username: 'jan',  graph_user: graph_user)
      receiver     = mock(:user, username: 'frank')
      content      = 'verhaal'
      usernames    = [sender.username, receiver.username]
      conversation = mock()
      fact_id = 10

      mixpanel = mock()
      options = {current_user: sender, mixpanel: mixpanel}

      interactor = CreateConversationWithMessageInteractor.new fact_id, usernames, sender.id, content, options

      interactor.should_receive(:track_mixpanel)

      User.should_receive(:find).with(sender.id).and_return(sender)
      should_receive_new_with_and_receive_execute(
        Commands::CreateConversation, fact_id, usernames, options).and_return(conversation)
      should_receive_new_with_and_receive_execute(
        Commands::CreateMessage, sender.id, content, conversation, options)
      should_receive_new_with_and_receive_execute(
        Commands::CreateActivity, graph_user, :created_conversation, conversation, nil, options)

      interactor.execute
    end

    it 'should delete the conversation when the message raises an exception' do
      conversation = mock()
      options = {current_user: mock(), mixpanel: mock()}

      interactor = CreateConversationWithMessageInteractor.new mock(), mock(), mock(), mock(), options

      should_receive_new_and_execute(Commands::CreateConversation).and_return(conversation)
      should_receive_new_and_execute(Commands::CreateMessage).and_raise('some_error')
      conversation.should_receive(:delete)

      expect{interactor.execute}.to raise_error('some_error')
    end
  end

  describe '.track_mixpanel' do
    it "should track an event" do
      current_user = mock(id: mock(to_s: mock))
      mixpanel = mock()
      options = {current_user: current_user, mixpanel: mixpanel}

      interactor = CreateConversationWithMessageInteractor.new mock(), mock(), mock(), mock(), options

      mixpanel.should_receive(:track_event).with(:conversation_created)
      mixpanel.should_receive(:increment_person_event).with(current_user.id.to_s, conversations_created: 1)

      interactor.track_mixpanel
    end
  end
end
