require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share_factlink.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  before do
    stub_classes 'Koala::Facebook::API', 'FactUrl'
  end

  describe '#call' do
    it 'should share a Factlink to Facebook' do
      fact      = double id: '1', title: 'title', host: 'example.org'
      token     = double
      client    = double
      namespace = 'namespace'
      fact_url  = double sharing_url: 'sharing_url'
      user      = double
      facebook_account = double token: token
      message = 'message'

      user.stub(:social_account).with('facebook').and_return(facebook_account)

      pavlov_options = { current_user: user }

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

      fact.stub(:trimmed_quote).with(100).and_return('quote')

      client.should_receive(:put_wall_post).with message,
        name: 'quote',
        link: 'sharing_url',
        caption: "example.org \u2014 title",
        description: 'Read more',
        picture: 'https://static.factlink.com/lib/dist/images/facebook-factlink-share-logo.png'

      command = described_class.new fact_id: fact.id, message: message,
                                    pavlov_options: pavlov_options

      command.call
    end

    it 'works without message' do
      fact      = double id: '1', title: 'title', host: 'example.org'
      token     = double
      client    = double
      namespace = 'namespace'
      fact_url  = double sharing_url: 'sharing_url'
      user      = double
      facebook_account = double token: token

      user.stub(:social_account).with('facebook').and_return(facebook_account)

      pavlov_options = { current_user: user }

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

      fact.stub(:trimmed_quote).with(100).and_return('quote')

      client.should_receive(:put_wall_post).with '',
        name: 'quote',
        link: 'sharing_url',
        caption: "example.org \u2014 title",
        description: 'Read more',
        picture: 'https://static.factlink.com/lib/dist/images/facebook-factlink-share-logo.png'

      command = described_class.new fact_id: fact.id, message: nil,
                                    pavlov_options: pavlov_options

      command.call
    end
  end
end
