require 'pavlov_helper'
require File.expand_path('../../../../app/interactors/commands/send_activity_mail_to_user.rb', __FILE__)

describe Commands::SendActivityMailToUser do
  include PavlovSupport
  
  before do
    stub_classes 'ActivityMailer'
  end

  describe '.execute' do
    it 'creates a mailer' do
      user = mock()
      activity = mock()

      mailer = mock()

      Commands::SendActivityMailToUser.any_instance.stub(authorized?: true)

      command = Commands::SendActivityMailToUser.new user, activity

      ActivityMailer.should_receive(:new_activity).with(user, activity).and_return mailer
      mailer.should_receive(:deliver)

      command.execute
    end
  end
end
