require 'pavlov_helper'
require './app/interactors/interactors/mails/mass_send_digest'

describe Interactors::Mails::MassSendDigest do
  include PavlovSupport


  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      fact_id = double
      url = double

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)
      described_class.any_instance.should_receive(:validate_string)
        .with(:url, url)

      interactor = described_class.new fact_id, url
    end
  end

  describe '#execute' do

    before do
      stub_classes 'User', 'Fact', 'DigestMailer'
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'sends an email to every user with receives_digest' do
      fact  = mock(id: mock)
      user1 = mock(id: mock)
      user2 = mock(id: mock)
      mail1 = double
      mail2 = double
      url   = double

      interactor = described_class.new fact.id, url

      User.stub receives_digest: [user1, user2]
      Fact.stub(:[]).with(fact.id).and_return(fact)
      DigestMailer.stub(:discussion_of_the_week).with(user1.id, fact.id, url).and_return(mail1)
      DigestMailer.stub(:discussion_of_the_week).with(user2.id, fact.id, url).and_return(mail2)

      mail1.should_receive :deliver
      mail2.should_receive :deliver

      interactor.execute
    end
  end
end
