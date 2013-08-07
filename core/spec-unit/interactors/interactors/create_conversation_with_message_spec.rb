require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/create_conversation_with_message.rb'

describe Interactors::CreateConversationWithMessage do
  include PavlovSupport

  before do
    stub_classes'Commands::CreateConversation', 'Commands::CreateMessage',
                'Commands::CreateActivity', 'User'
  end

  describe '#call' do
    it 'should call the right commands' do
      graph_user   = double;
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
      Pavlov.should_receive(:old_command).with(:create_conversation, fact_id, usernames, pavlov_options).
        and_return(conversation)
      Pavlov.should_receive(:old_command).with(:create_message, sender.id, content, conversation, pavlov_options)
      Pavlov.should_receive(:old_command).with(:create_activity, graph_user, :created_conversation, conversation, nil, pavlov_options)

      interactor.call
    end

    it 'should delete the conversation when the message raises an exception' do
      fact_id = double
      usernames = double
      sender_id = double
      content = double
      conversation = double

      described_class.any_instance.should_receive(:authorized?).and_return true

      interactor = described_class.new fact_id: fact_id,
        recipient_usernames: usernames, sender_id: sender_id,
        content: content

      interactor.should_receive(:old_command).with(:create_conversation, fact_id, usernames).and_return(conversation)
      interactor.should_receive(:old_command).with(:create_message, sender_id, content, conversation).and_raise('some_error')
      conversation.should_receive(:delete)

      expect{interactor.call}.to raise_error('some_error')
    end
  end

  describe '.authorized?' do
    it "returns true when the sender has the same user_id as the current_user" do
      current_user = double(id:double(to_s: double))
      pavlov_options = {current_user: current_user}

      interactor = described_class.new fact_id: double, recipient_usernames: double,
        sender_id: current_user.id, content: double, pavlov_options:pavlov_options

      expect(interactor.authorized?).to eq true
    end

    it "returns false when the sender has a different user_id as the current_user" do
      user_a = double(id: double(to_s: double))
      user_b = double(id: double(to_s: double))

      pavlov_options = {current_user: user_a}
      hash = { fact_id: double, recipient_usernames: double, sender_id: user_b.id,
        content: double, pavlov_options: pavlov_options }

      expect_validating( hash )
        .to raise_error(Pavlov::AccessDenied)
    end
  end
end
