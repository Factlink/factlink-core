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

  describe '#execute' do

    before do
      stub_classes 'User', 'Fact', 'DigestMailer'
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'sends an email to every user with receives_digest' do
      user_notification1 = double
      user_notification2 = double

      fact  = double(id: double)
      user1 = double(id: double, user_notification: user_notification1)
      user2 = double(id: double, user_notification: user_notification2)
      mail1 = double
      mail2 = double
      url   = double

      interactor = described_class.new fact_id: fact.id, url: url

      User.stub active: [user1, user2]
      Fact.stub(:[]).with(fact.id).and_return(fact)
      DigestMailer.stub(:discussion_of_the_week).with(user1.id, fact.id, url).and_return(mail1)
      DigestMailer.stub(:discussion_of_the_week).with(user2.id, fact.id, url).and_return(mail2)
      user_notification1.stub(:can_receive?).with('digest').and_return(false)
      user_notification2.stub(:can_receive?).with('digest').and_return(true)

      mail2.should_receive :deliver

      interactor.execute
    end
  end
end
