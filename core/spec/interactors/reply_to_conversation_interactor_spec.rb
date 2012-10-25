require File.expand_path('../../../app/interactors/reply_to_conversation_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe ReplyToConversationInteractor do

  before do
    stub_const('Commands::CreateMessage', Class.new)
    stub_const('Commands::CreateActivity', Class.new)
    stub_const('User', Class.new)
    stub_const('Conversation', Class.new)
  end

  describe '.execute' do
    it 'correctly' do
      graph_user   = mock();
      sender       = mock(:user, id: 13, graph_user: graph_user)
      content      = 'geert'
      conversation = mock(:conversation, id: 20)

      User.should_receive(:find).with(sender.id).and_return(sender)
      Conversation.should_receive(:find).with(conversation.id).and_return(conversation)
      should_receive_new_with_and_receive_execute(
        Commands::CreateMessage, sender.id, content, conversation, current_user: sender)
      should_receive_new_with_and_receive_execute(
        Commands::CreateActivity, graph_user, :replied_conversation, conversation, current_user: sender)

      ReplyToConversationInteractor.perform conversation.id, sender.id, content, current_user: sender
    end
  end
end
