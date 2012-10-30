require File.expand_path('../../../app/interactors/reply_to_conversation_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe ReplyToConversationInteractor do

  before do
    stub_classes 'Commands::CreateMessage', 'Commands::CreateActivity',
                 'User', 'Conversation'
  end

  describe '.execute' do
    it 'correctly' do
      graph_user   = mock();
      sender       = mock(:user, id: 13, graph_user: graph_user)
      content      = 'geert'
      conversation = mock(:conversation, id: 20)
      message      = mock()

      Conversation.should_receive(:find).with(conversation.id.to_s).and_return(conversation)
      should_receive_new_with_and_receive_execute(
        Commands::CreateMessage, sender.id.to_s, content, conversation, current_user: sender).and_return(message)
      
      User.should_receive(:find).with(sender.id.to_s).and_return(sender)
      should_receive_new_with_and_receive_execute(
        Commands::CreateActivity, graph_user, :replied_message, message, nil, current_user: sender)

      ReplyToConversationInteractor.perform conversation.id.to_s, sender.id.to_s, content, current_user: sender
    end
  end
end
