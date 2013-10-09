require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/create_conversation_with_message.rb'

describe Interactors::CreateConversationWithMessage do
  include PavlovSupport

  before do
    stub_classes'Commands::CreateConversation', 'Commands::CreateMessage',
                'Commands::CreateActivity', 'User'
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
      expect_validating(content: 'a' * 5001)
        .to fail_validation 'content cannot be longer than 5000 characters.'
    end
  end

  describe '#call' do
    it 'should call the right commands' do
      graph_user   = double
      sender       = double(:user, id: 13, username: 'jan',  graph_user: graph_user)
      receiver     = double(:user, username: 'frank')
      content      = 'verhaal'
      usernames    = [sender.username, receiver.username]
      conversation = double
      fact_id = 10

      mixpanel = double
      pavlov_options = { current_user: sender, mixpanel: mixpanel }

      interactor = described_class.new fact_id: fact_id,
        recipient_usernames: usernames, sender_id: sender.id,
        content: content, pavlov_options: pavlov_options

      interactor.should_receive(:mp_track).with("Factlink: Created conversation", {:recipients=>["jan", "frank"], :fact_id=>10})
      interactor.should_receive(:mp_increment_person_property)
                .with(:conversations_created)

      User.should_receive(:find).with(sender.id).and_return(sender)
      Pavlov.should_receive(:command)
            .with(:'create_conversation',
                      fact_id: fact_id, recipient_usernames: usernames,
                      pavlov_options: pavlov_options)
            .and_return(conversation)
      Pavlov.should_receive(:command)
            .with(:'create_message',
                      sender_id: sender.id, content: content,
                      conversation: conversation, pavlov_options: pavlov_options)
      Pavlov.should_receive(:command)
            .with(:'create_activity',
                      graph_user: graph_user, action: :created_conversation,
                      subject: conversation, object: nil,
                      pavlov_options: pavlov_options)

      interactor.call
    end

    it 'should delete the conversation when the message raises an exception' do
      fact_id = double
      usernames = double
      sender = double id: 13
      content = 'something'
      conversation = double

      pavlov_options = { current_user: sender }

      interactor = described_class.new fact_id: fact_id,
        recipient_usernames: usernames, sender_id: sender.id,
        content: content, pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:'create_conversation',
                      fact_id: fact_id, recipient_usernames: usernames, pavlov_options: pavlov_options)
            .and_return(conversation)
      Pavlov.should_receive(:command)
            .with(:'create_message',
                      sender_id: sender.id, content: content, conversation: conversation, pavlov_options: pavlov_options)
            .and_raise('some_error')
      conversation.should_receive(:delete)

      expect { interactor.call }.to raise_error('some_error')
    end
  end

  describe '.authorized?' do
    it "returns true when the sender has the same user_id as the current_user" do
      current_user = double(id: 'a1')
      pavlov_options = {current_user: current_user}

      interactor = described_class.new fact_id: double, recipient_usernames: double,
        sender_id: current_user.id, content: 'foo', pavlov_options:pavlov_options

      expect(interactor.authorized?).to eq true
    end

    it "returns false when the sender has a different user_id as the current_user" do
      current_user = double(id: '1')
      sender = double(id: '2')

      pavlov_options = {current_user: current_user}
      interactor = described_class.new fact_id: double, recipient_usernames: double, sender_id: sender.id,
        content: 'foo', pavlov_options: pavlov_options

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
end
