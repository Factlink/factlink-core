require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/create_conversation_with_message.rb'

describe Interactors::CreateConversationWithMessage do
  include PavlovSupport

  before do
    stub_classes'Commands::CreateConversation', 'Commands::CreateMessage',
                'Commands::CreateActivity', 'User'
  end

  describe '.call' do
    it 'should call the right commands' do
      graph_user   = mock;
      sender       = mock(:user, id: 13, username: 'jan',  graph_user: graph_user)
      receiver     = mock(:user, username: 'frank')
      content      = 'verhaal'
      usernames    = [sender.username, receiver.username]
      conversation = mock
      fact_id = 10

      mixpanel = mock
      options = {current_user: sender, mixpanel: mixpanel}

      interactor = Interactors::CreateConversationWithMessage.new fact_id, usernames, sender.id, content, options

      interactor.should_receive(:track_mixpanel)

      User.should_receive(:find).with(sender.id).and_return(sender)
      should_receive_new_with_and_receive_call(
        Commands::CreateConversation, fact_id, usernames, options).and_return(conversation)
      should_receive_new_with_and_receive_call(
        Commands::CreateMessage, sender.id, content, conversation, options)
      should_receive_new_with_and_receive_call(
        Commands::CreateActivity, graph_user, :created_conversation, conversation, nil, options)

      interactor.call
    end

    it 'should delete the conversation when the message raises an exception' do
      conversation = mock

      Interactors::CreateConversationWithMessage.any_instance.should_receive(:authorized?).and_return true

      interactor = Interactors::CreateConversationWithMessage.new mock, mock, mock, mock

      should_receive_new_and_call(Commands::CreateConversation).and_return(conversation)
      should_receive_new_and_call(Commands::CreateMessage).and_raise('some_error')
      conversation.should_receive(:delete)

      expect{interactor.call}.to raise_error('some_error')
    end
  end

  describe '.track_mixpanel' do
    it "should track an event" do
      mixpanel = mock
      current_user = mock(id: mock(to_s: mock))
      options = {mixpanel: mixpanel, current_user: current_user}

      Interactors::CreateConversationWithMessage.any_instance.should_receive(:authorized?).and_return true

      interactor = Interactors::CreateConversationWithMessage.new mock, mock, mock, mock, options

      mixpanel.should_receive(:track_event).with(:conversation_created)
      mixpanel.should_receive(:increment_person_event).with(current_user.id.to_s, conversations_created: 1)

      interactor.track_mixpanel
    end
  end

  describe '.authorized?' do
    it "returns true when the sender has the same user_id as the current_user" do
      current_user = mock(id:mock(to_s: mock))
      options = {current_user: current_user}

      interactor = Interactors::CreateConversationWithMessage.new mock, mock, current_user.id, mock, options

      expect(interactor.authorized?).to eq true
    end

    it "returns false when the sender has a different user_id as the current_user" do
      user_a = mock(id: mock(to_s: mock))
      user_b = mock(id: mock(to_s: mock))

      options = {current_user: user_a}

      initialization = lambda do
        Interactors::CreateConversationWithMessage.new mock, mock, user_b.id, mock, options
      end

      expect(initialization).to raise_error(Pavlov::AccessDenied)
    end
  end
end
