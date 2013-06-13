require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      message = 'message'
      fact_id = '1'

      fact = stub( url: mock )
      current_user = mock

      token = mock
      secret = mock
      identities = {
        'facebook' =>  {
          'credentials' => {
            'token' => token, 'secret' => secret}
            }
          }
      current_user.stub( identities: identities )

      client = mock
      Koala::Facebook::API.stub(:new)
                          .with(token)
                          .and_return(client)

      client.should_receive(:put_connections)
            .with("me", "factlinkdevelopment:share", factlink: fact.url)

      # TODO: I don't want to pass `current_user: current_user` here. Why is this needed?
      Pavlov.stub(:query)
            .with(:'facts/get_dead', fact_id, current_user: current_user)
            .and_return(fact)

      command = described_class.new message, fact_id, current_user: current_user

      command.call
    end
  end

  describe '#validate' do
    it 'should validate if the message is a nonempty_string' do
      message = 'message'

      described_class.any_instance
        .should_receive(:validate_nonempty_string)
        .with(:message, message)

      command = described_class.new message, '1'
    end

    it 'should validate if the fact_id is an integer string' do
      fact_id = '1'

      described_class.any_instance
        .should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)

      command = described_class.new 'message', fact_id
    end
  end
end
