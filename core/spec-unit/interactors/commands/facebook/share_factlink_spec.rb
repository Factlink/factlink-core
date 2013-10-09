require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API', 'FactUrl'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      fact      = double id: '1', displaystring: 'displaystring',
                         title: 'title', host: 'example.org'
      token     = double
      client    = double
      namespace = 'namespace'
      fact_url = double sharing_url: 'sharing_url'

      identities = {
        'facebook' =>  {
          'credentials' => {
            'token' => token, 'secret' => double
          }
        }
      }

      pavlov_options = { current_user: double(identities: identities),
                         facebook_app_namespace: namespace }

      Koala::Facebook::API.stub(:new)
                          .with(token)
                          .and_return(client)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.stub(:query)
            .with(:'facts/get_dead',
                      id: fact.id, pavlov_options: pavlov_options)
            .and_return(fact)

      Pavlov.stub(:query)
            .with(:'facts/quote', fact: fact, max_length: 100, pavlov_options: pavlov_options)
            .and_return('quote')

      client.should_receive(:put_wall_post).with '',
        name: 'quote',
        link: 'sharing_url',
        caption: "example.org \u2014 title",
        description: 'Read more',
        picture: 'http://cdn.factlink.com/1/fact-wheel-questionmark.png'

      command = described_class.new fact_id: fact.id, pavlov_options: pavlov_options

      command.call
    end

    it 'works without a host' do
      fact      = double id: '1', displaystring: 'displaystring',
                         title: 'title', host: nil
      token     = double
      client    = double
      namespace = 'namespace'
      fact_url = double sharing_url: 'sharing_url'

      identities = {
        'facebook' =>  {
          'credentials' => {
            'token' => token, 'secret' => double
          }
        }
      }

      pavlov_options = { current_user: double(identities: identities),
                         facebook_app_namespace: namespace }

      Koala::Facebook::API.stub(:new)
                          .with(token)
                          .and_return(client)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.stub(:query)
            .with(:'facts/get_dead',
                      id: fact.id, pavlov_options: pavlov_options)
            .and_return(fact)

      Pavlov.stub(:query)
            .with(:'facts/quote', fact: fact, max_length: 100, pavlov_options: pavlov_options)
            .and_return('quote')

      client.should_receive(:put_wall_post).with '',
        name: 'quote',
        link: 'sharing_url',
        caption: '',
        description: 'Read more',
        picture: 'http://cdn.factlink.com/1/fact-wheel-questionmark.png'

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
