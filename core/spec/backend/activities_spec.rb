require 'spec_helper'

describe Backend::Activities do
  include PavlovSupport
  include FeedHelper

  describe '.send_mail_for_activity' do
    it 'sends mails' do
      user = create :user, :confirmed, receives_mailed_notifications: true

      mails_by_username_and_activity = []
      SendActivityMailToUser.stub(:perform) do |user_id, activity_id|
        mails_by_username_and_activity << {
          username: User.find(user_id).username,
          subject_class: Activity[activity_id].subject_class,
          object_class: Activity[activity_id].object_class,
          action: Activity[activity_id].action
        }
      end

      create_default_activities_for user, send_mails: true

      verify { mails_by_username_and_activity }
    end
  end
end
