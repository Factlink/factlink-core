require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      fact     = stub id: '1', url: mock
      message  = 'message'
      token    = mock
      client   = mock

      identities = {
        'facebook' =>  {
          'credentials' => {
            'token' => token, 'secret' => mock}
            }
          }

      pavlov_options = { current_user: stub(identities: identities),
                         facebook_app_namespace: 'namespace' }

      client.should_receive(:put_connections)
            .with("me", "factlinkdevelopment:share", factlink: fact.url)

      Koala::Facebook::API.stub(:new)
                          .with(token)
                          .and_return(client)

      Pavlov.stub(:query)
            .with(:'facts/get_dead', fact.id, pavlov_options)
            .and_return(fact)

      command = described_class.new fact.id, message, pavlov_options

      command.call
    end
  end

end
