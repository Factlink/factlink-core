require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/reply_to_conversation.rb'

describe Interactors::ReplyToConversation do
  include PavlovSupport

  before do
    stub_classes 'Commands::CreateMessage', 'Commands::CreateActivity',
                 'User', 'Conversation'
  end

  describe '.validate' do
    it 'throws error on empty message' do
      expect_validating(content: '')
        .to fail_validation 'content cannot be empty'
    end

    it 'throws error on message with just whitespace' do
      expect_validating(content: " \t\n")
        .to fail_validation 'content cannot be empty'
    end

    it 'throws error on too long message' do
      expect_validating(content: 'a'*5001)
        .to fail_validation 'content cannot be longer than 5000 characters.'
    end
  end

  describe '#call' do
    it 'correctly' do
      graph_user   = double
      sender       = double(:user, id: 13, graph_user: graph_user)
      content      = 'geert'
      conversation = double(:conversation, id: 20)
      message      = double
      options      = {current_user: sender}

      interactor = described_class.new conversation_id: conversation.id.to_s,
        sender_id: sender.id.to_s, content: content, pavlov_options: options

      Conversation.should_receive(:find).with(conversation.id.to_s).and_return(conversation)
      Pavlov.should_receive(:command)
            .with(:'create_message',
                      sender_id: sender.id.to_s, content: content,
                      conversation: conversation, pavlov_options: options)
            .and_return(message)

      User.should_receive(:find).with(sender.id.to_s).and_return(sender)
      Pavlov.should_receive(:command)
            .with(:'create_activity',
                      graph_user: graph_user, action: :replied_message,
                      subject: message, object: nil, pavlov_options: options)

      # TODO: refactor mixpanel utility class such that
      #       we don't need to check expectations on the object under test
      interactor.should_receive(:mp_increment_person_property)
                .with(:replies_created)
      interactor.should_receive(:mp_track).with("Conversation: Replied to conversation", {:conversation_id=>"20"})

      interactor.call
    end
  end
end
