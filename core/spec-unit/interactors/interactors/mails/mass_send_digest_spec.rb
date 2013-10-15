require 'pavlov_helper'
require './app/interactors/interactors/mails/mass_send_digest'

describe Interactors::Mails::MassSendDigest do
  include PavlovSupport


  describe 'validations' do
    it 'requires fact_id to be an integer string' do
      expect_validating(fact_id: 1, url: 'url')
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires url to be an string' do
      expect_validating(fact_id: '1', url: 1024)
        .to fail_validation('url should be a string.')
    end
  end

  describe '#call' do

    before do
      stub_classes 'UserReceiving', 'Fact', 'DigestMailer'
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'sends an email to every user with receives_digest' do
      fact  = double(id: '1')
      user = double(id: '1a')
      mail = double
      url = 'http://example.org'

      interactor = described_class.new fact_id: fact.id, url: url

      UserReceiving.stub(:users_receiving).with('digest').and_return([user])
      Fact.stub(:[]).with(fact.id).and_return(fact)
      DigestMailer.stub(:discussion_of_the_week).with(user.id, fact.id, url).and_return(mail)

      mail.should_receive :deliver

      interactor.call
    end
  end
end
