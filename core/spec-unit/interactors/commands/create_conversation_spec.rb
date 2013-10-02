require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_conversation.rb'

describe Commands::CreateConversation do
  include PavlovSupport

  let(:fact_id) {10}

  before do
    stub_classes 'Conversation', 'Queries::UserByUsername', 'Fact'
  end

  it 'throws an error when recipient_usernames is not a list' do
    expect_validating(fact_id: fact_id, recipients_usernames: nil)
      .to fail_validation 'recipient_usernames should be a list'
  end

  it 'throws an error when recipient_usernames is an empty list' do
    expect_validating(fact_id: fact_id, recipient_usernames: [])
      .to fail_validation 'recipient_usernames should not be empty'
  end

  describe '#call' do
    it 'should execute correctly' do
      username = 'username'
      command = described_class.new fact_id: fact_id,
        recipient_usernames: [username]
      recipients = double('recipients')
      conversation = double('conversation', recipients: recipients)
      Conversation.stub(:new).and_return(conversation)
      user = double

      Pavlov.stub(:query)
            .with(:user_by_username, username: username)
            .and_return(user)

      fact_data_id = 'abc'
      fact = double('fact', data_id: fact_data_id)
      Fact.stub(:[]).with(fact_id).and_return(fact)

      recipients.should_receive(:<<).with(user)
      conversation.should_receive(:fact_data_id=).with(fact_data_id)
      conversation.should_receive(:save)

      command.call
    end

    it 'should throw when an invalid username is given' do
      username = 'username'
      command = described_class.new fact_id: fact_id,
        recipient_usernames: [username]
      Conversation.stub(:new).and_return(double('conversation'))

      Pavlov.stub(:query)
            .with(:user_by_username, username: username)
            .and_return(nil)

      expect {command.call}.to raise_error(Pavlov::ValidationError, 'user_not_found')
    end
  end
end
