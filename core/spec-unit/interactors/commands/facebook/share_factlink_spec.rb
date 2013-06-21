require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      fact      = stub id: '1', url: mock
      message   = 'message'
      token     = mock
      client    = mock
      namespace = 'namespace'

      identities = {
        'facebook' =>  {
          'credentials' => {
            'token' => token, 'secret' => mock
          }
        }
      }

      pavlov_options = { current_user: stub(identities: identities),
                         facebook_app_namespace: namespace }

      Koala::Facebook::API.stub(:new)
                          .with(token)
                          .and_return(client)

      Pavlov.stub(:query)
            .with(:'facts/get_dead', fact.id, pavlov_options)
            .and_return(fact)

      client.should_receive(:put_connections)
            .with("me", "#{namespace}:share", factlink: fact.url)

      command = described_class.new fact.id, message, pavlov_options

      command.call
    end
  end


  describe '#validate' do
    it 'if the message and @options[:facebook_app_namespace]
        are a nonempty_string' do
      message        = 'message'
      namespace      = 'factlinkapp'
      pavlov_options = { facebook_app_namespace: namespace }

      described_class.any_instance
        .should_receive(:validate_nonempty_string)
        .with(:message, message)

      described_class.any_instance
        .should_receive(:validate_nonempty_string)
        .with(:facebook_app_namespace, namespace)

      command = described_class.new '1', message, pavlov_options
    end

    it 'if the fact_id is an integer string' do
      fact_id = '1'

      described_class.any_instance
        .should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)

      command = described_class.new fact_id, 'message',
                                    facebook_app_namespace: 'namespace'
    end
  end
end