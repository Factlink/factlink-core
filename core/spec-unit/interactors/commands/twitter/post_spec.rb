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
      user = double(identities: identities)

      client = double
      Twitter::Client.stub(:new)
        .with(oauth_token: token, oauth_token_secret: secret)
        .and_return(client)

      client.should_receive(:update)
        .with(message)

      command = described_class.new message: message,
        pavlov_options: { current_user: user }
      command.call
    end

  end



  describe 'validation' do
    it 'requires a message' do
      expect_validating(message: '')
        .to fail_validation('message should be a nonempty string.')
    end
  end

  describe '#validate' do
    it 'throws an error if no twitter account is linked' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      message  = 'message'
      user = double(identities: {'twitter' => nil})

      expect_validating( message: message, pavlov_options: { current_user: user } )
        .to fail_validation('no twitter account linked')
    end
  end
end
