require 'spec_helper'

describe 'fact' do
  include PavlovSupport

  let(:current_user)  { create :full_user }
  let(:twitter_user)  { create :full_user, :connected_twitter }
  let(:facebook_user) { create :full_user, :connected_facebook }

  it 'can be created' do
    displaystring = 'displaystring'

    as(current_user) do |pavlov|
      fact = pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: {})

      result = pavlov.interactor(:'facts/get', id: fact.id)

      expect(result.data.displaystring).to eq displaystring
    end
  end

  it 'can be posted to Twitter' do
    displaystring = 'displaystring'
    twitter_client = double

    stub_classes 'Twitter', 'Twitter::Client'
    Twitter.stub configuration: double(short_url_length_https: 10)
    Twitter::Client.stub(:new)
      .with(oauth_token: 'token', oauth_token_secret: 'secret')
      .and_return(twitter_client)

    twitter_client.should_receive(:update)
                  .with("\u201c" + "displaystring" + "\u201d" + " http://localhost:3000/displaystring/f/1")

    as(twitter_user) do |pavlov|
      pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: { twitter: true })
    end
  end

  it 'can be posted to Facebook' do
    displaystring = 'displaystring'
    facebook_client = double

    stub_classes 'Koala::Facebook::API'
    Koala::Facebook::API.stub(:new)
      .with('token')
      .and_return(facebook_client)

    facebook_client.should_receive(:put_connections)
                   .with("me", "factlinktest:share", factlink: "http://localhost:3000/facts/1")

    as(facebook_user) do |pavlov|
      pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: { facebook: true })
    end
  end

end
