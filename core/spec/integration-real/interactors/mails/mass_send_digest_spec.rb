require 'spec_helper'

describe Interactors::Mails::MassSendDigest do
  include PavlovSupport

  before do
    @user = create :approved_confirmed_user, receives_digest: true
    @user_not_receiving = create :approved_confirmed_user, receives_digest: false

    @url = 'url'

    as(@user) do |pavlov|
      @fact = pavlov.interactor(:'facts/create', displaystring: 'displaystring', url: '', title: 'title', sharing_options: {})
      @mails = pavlov.interactor(:'mails/mass_send_digest', fact_id: @fact.id, url: @url)
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

  it 'does not display the header image' do
    header_image_tag = 'src="http://cdn.factlink.com/1/emailLogo.png"'
    expect(@mails[0].body.encoded).not_to match(header_image_tag)
  end
end
