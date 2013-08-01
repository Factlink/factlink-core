require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      fact      = stub id: '1', url: mock(fact_url: 'fact_url')
      token     = double
      client    = double
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

      Pavlov.stub(:old_query)
            .with(:'facts/get_dead', fact.id, pavlov_options)
            .and_return(fact)

      client.should_receive(:put_connections)
            .with("me", "#{namespace}:share", factlink: fact.url.fact_url)

      command = described_class.new fact_id: fact.id, pavlov_options: pavlov_options

      command.call
    end
  end


  describe 'validations' do
    it 'requires integer fact_id' do
      expect_validating(fact_id: '')
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires the pavlov_options[:facebook_app_namespace]
        to be a nonempty_string' do
      expect_validating(fact_id: '1')
        .to fail_validation('facebook_app_namespace should be a nonempty string.')
    end
  end
end
