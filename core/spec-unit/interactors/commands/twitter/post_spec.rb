require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/post'

describe Commands::Twitter::Post do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub validate: true
      stub_classes 'Twitter::Client'
    end

    it 'calls Twitter::Client#update' do
      username = 'henk'
      message  = 'some message'

      token  = 'qwerty'
      secret = 'asdf'
      identities = {'twitter' => {'credentials' => {'token' => token, 'secret' => secret}}}
      user = mock(identities: identities)

      query = described_class.new username, message

      query.stub(:query).
        with(:user_by_username, username).
        and_return(user)

      client = mock
      Twitter::Client.stub(:new).
        with(oauth_token: token, oauth_token_secret: secret).
        and_return(client)
      client.should_receive(:update).
        with(message)

      query.execute
    end

    it 'throws an error if no twitter account is linked' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      username = 'henk'
      message  = 'some message'

      user = mock(identities: {'twitter' => nil})

      query = described_class.new username, message

      query.stub(:query).
        with(:user_by_username, username).
        and_return(user)

      expect { query.execute }.
        to raise_error(Pavlov::ValidationError, 'no twitter account linked')
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      username = mock
      message  = mock

      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:username, username)
      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:message, message)

      query = described_class.new username, message
    end
  end
end
