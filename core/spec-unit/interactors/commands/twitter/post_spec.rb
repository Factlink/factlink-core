require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/post'

describe Commands::Twitter::Post do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Twitter::Client'
    end

    it 'calls Twitter::Client#update' do
      message  = 'some message'
      token  = 'qwerty'
      secret = 'asdf'
      identities = {'twitter' => {'credentials' => {'token' => token, 'secret' => secret}}}
      user = mock(username: 'henk', identities: identities)

      Pavlov.stub(:query)
        .with(:user_by_username, user.username)
        .and_return(user)

      client = mock
      Twitter::Client.stub(:new)
        .with(oauth_token: token, oauth_token_secret: secret)
        .and_return(client)

      client.should_receive(:update).
        with(message)

      command = described_class.new user.username, message
      command.call
    end

  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      message  = 'message'
      user = mock(username: 'henk', identities: {'twitter' => {}})

      Pavlov.stub(:query)
        .with(:user_by_username, user.username)
        .and_return(user)

      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:username, user.username)
      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:message, message)

      command = described_class.new user.username, message
    end

    it 'throws an error if no twitter account is linked' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      message  = 'message'
      user = mock(username: 'henk', identities: {'twitter' => nil})

      Pavlov.stub(:query)
        .with(:user_by_username, user.username)
        .and_return(user)

      expect { described_class.new user.username, message }.
        to raise_error(Pavlov::ValidationError, 'no twitter account linked')
    end
  end
end
