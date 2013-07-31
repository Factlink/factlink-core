require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/post'

describe Commands::Twitter::Post do
  include PavlovSupport

  before do
    stub_classes 'Twitter::Client'
  end

  describe '#call' do
    it 'calls Twitter::Client#update' do
      message  = 'some message'
      token  = 'qwerty'
      secret = 'asdf'
      identities = {'twitter' => {'credentials' => {'token' => token, 'secret' => secret}}}
      user = mock(identities: identities)

      client = double
      Twitter::Client.stub(:new)
        .with(oauth_token: token, oauth_token_secret: secret)
        .and_return(client)

      client.should_receive(:update)
        .with(message)

      command = described_class.new message, current_user: user
      command.call
    end

  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      message  = 'message'
      user = mock(identities: {'twitter' => {}})

      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:message, message)

      command = described_class.new message, current_user: user
    end

    it 'throws an error if no twitter account is linked' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      message  = 'message'
      user = mock(identities: {'twitter' => nil})

      expect { described_class.new message, current_user: user }
        .to raise_error(Pavlov::ValidationError, 'no twitter account linked')
    end
  end
end
