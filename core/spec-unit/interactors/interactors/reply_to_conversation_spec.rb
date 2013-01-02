require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/reply_to_conversation.rb'

describe Interactors::ReplyToConversation do
  include PavlovSupport

  before do
    stub_classes 'Commands::CreateMessage', 'Commands::CreateActivity',
                 'User', 'Conversation'
  end

  describe '.call' do
    it 'correctly' do
      graph_user   = mock();
      sender       = mock(:user, id: 13, graph_user: graph_user)
      content      = 'geert'
      conversation = mock(:conversation, id: 20)
      message      = mock()

      interactor = Interactors::ReplyToConversation.new conversation.id.to_s, sender.id.to_s, content, current_user: sender

      Conversation.should_receive(:find).with(conversation.id.to_s).and_return(conversation)
      should_receive_new_with_and_receive_call(
        Commands::CreateMessage, sender.id.to_s, content, conversation, current_user: sender).and_return(message)

      User.should_receive(:find).with(sender.id.to_s).and_return(sender)
      should_receive_new_with_and_receive_call(
        Commands::CreateActivity, graph_user, :replied_message, message, nil, current_user: sender)

      interactor.should_receive(:track_mixpanel)

      interactor.call
    end
  end

  describe ".track_mixpanel" do
    it "calls the right mixpanel methods" do
      mixpanel = mock()
      current_user = mock(id: 1)
      options = {current_user: current_user, mixpanel: mixpanel}
      interactor = Interactors::ReplyToConversation.new mock(), current_user.id.to_s, mock(), options

      mixpanel.should_receive(:increment_person_event).with(current_user.id.to_s, replies_created: 1)
      mixpanel.should_receive(:track_event).with(:reply_created)

      interactor.track_mixpanel
    end
  end
end
