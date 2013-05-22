require 'spec_helper'

describe Interactors::Mails::MassSendDigest do
  include PavlovSupport

  before do
    @user = FactoryGirl.create :approved_confirmed_user, receives_digest: true
    @user_not_receiving = FactoryGirl.create :approved_confirmed_user, receives_digest: false

    @url = 'url'

    as(@user) do |pavlov|
      @fact = pavlov.interactor :'facts/create', 'displaystring', '', 'title'
      @mails = pavlov.interactor :'mails/mass_send_digest', @fact.id, @url
    end
  end

  it 'only sends to @users receiving the digest' do
    expect(@mails.size).to eq 1
    expect(@mails[0].to).to eq [@user.email]
  end

  it 'renders the subject' do
    expect(@mails[0].subject).to eq 'Discussion of the Week'
  end

  it 'renders the factlink displaystring' do
    expect(@mails[0].body.encoded).to match(@fact.data.displaystring)
  end

  it 'renders the url' do
    expect(@mails[0].body.encoded).to match(@url)
  end
end
