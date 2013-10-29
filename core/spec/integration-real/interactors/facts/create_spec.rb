require 'spec_helper'

describe 'fact' do
  include PavlovSupport

  it 'can be created' do
    displaystring = 'displaystring'
    user = create :full_user

    as(user) do |pavlov|
      fact = pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: {})

      result = pavlov.interactor(:'facts/get', id: fact.id)

      expect(result.data.displaystring).to eq displaystring
    end
  end

  it 'can be posted to Twitter' do
    displaystring = 'displaystring'
    twitter_client = double
    user = create :full_user
    create :social_account, :twitter, user: user

    stub_classes 'Twitter', 'Twitter::Client'
    Twitter.stub configuration: double(short_url_length_https: 10)
    Twitter::Client.stub(:new)
      .with(oauth_token: 'token', oauth_token_secret: 'secret')
      .and_return(twitter_client)

    twitter_client.should_receive(:update)
                  .with("\u201c" + "displaystring" + "\u201d" + " http://localhost:3000/displaystring/f/1")

    as(user) do |pavlov|
      pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: { twitter: true })
    end
  end

  it 'can be posted to Facebook' do
    displaystring = 'displaystring'
    facebook_client = double
    user = create :full_user
    create :social_account, :facebook, user: user

    stub_classes 'Koala::Facebook::API'
    Koala::Facebook::API.stub(:new)
      .with('token')
      .and_return(facebook_client)

    facebook_client.should_receive(:put_wall_post).with '',
        name: "\u201c" + "displaystring" + "\u201d",
        link: 'http://localhost:3000/displaystring/f/1',
        caption: '',
        description: 'Read more',
        picture: 'http://cdn.factlink.com/1/facebook-factwheel-logo.png'

    as(user) do |pavlov|
      pavlov.interactor(:'facts/create', displaystring: displaystring, url: '', title: '', sharing_options: { facebook: true })
    end
  end

end
