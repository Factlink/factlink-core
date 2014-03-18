require 'pavlov_helper'
require_relative '../../app/workers/send_activity_mail_to_user.rb'

describe SendActivityMailToUser do
  include PavlovSupport

  before do
    stub_classes 'ActivityMailer'
  end

  describe '#call' do
    it 'creates a mailer' do
      user_id = double
      activity_id = double
      mailer = double

      ActivityMailer.stub(:new_activity)
                    .with(user_id, activity_id)
                    .and_return mailer

      mailer.should_receive(:deliver)

      described_class.perform user_id, activity_id
    end
  end
end
