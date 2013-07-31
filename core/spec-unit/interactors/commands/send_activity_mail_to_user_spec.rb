require 'pavlov_helper'
require_relative '../../../app/interactors/commands/send_activity_mail_to_user.rb'

describe Commands::SendActivityMailToUser do
  include PavlovSupport

  before do
    stub_classes 'ActivityMailer'
  end

  describe '#call' do
    it 'creates a mailer' do
      user_id = double
      activity_id = double
      mailer = double

      command = described_class.new user_id, activity_id

      ActivityMailer.stub(:new_activity)
                    .with(user_id, activity_id)
                    .and_return mailer

      mailer.should_receive(:deliver)

      command.call
    end
  end
end
