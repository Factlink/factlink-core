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
      graph_user   = mock
      sender       = mock(:user, id: 13, graph_user: graph_user)
      content      = 'geert'
      conversation = mock(:conversation, id: 20)
      message      = mock
      options      = {current_user: sender}

      interactor = Interactors::ReplyToConversation.new conversation.id.to_s, sender.id.to_s, content, options

      Conversation.should_receive(:find).with(conversation.id.to_s).and_return(conversation)
      Pavlov.should_receive(:old_command)
            .with(:create_message, sender.id.to_s, content, conversation, options)
            .and_return(message)

      User.should_receive(:find).with(sender.id.to_s).and_return(sender)
      Pavlov.should_receive(:old_command)
                .with(:create_activity, graph_user, :replied_message, message, nil, options)

      # TODO: refactor mixpanel utility class such that
      #       we don't need to check expectations on the object under test
      interactor.should_receive(:mp_increment_person_property)
                .with(:replies_created)
      interactor.should_receive(:mp_track).with(:reply_created)

      interactor.call
    end
  end
end
