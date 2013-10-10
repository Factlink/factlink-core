require 'spec_helper'

describe UserNotification do

  subject(:user) { create :user }

  describe '#unsubscribe' do
    it "unsubscribes you from a digest mailing" do
      expect(user.receives_digest).to be_true

      user.user_notification.unsubscribe('digest')

      expect(user.receives_digest).to be_false
    end

    it "unsubscribes you persisted from a digest mailing" do
      expect(user.receives_digest).to be_true

      user.user_notification.unsubscribe('digest')

      refetched_user = User.find(user.id)

      expect(refetched_user.receives_digest).to be_false
    end

    it "unsubscribes you from a mailed_notifications mailing" do
      expect(user.receives_mailed_notifications).to be_true

      user.user_notification.unsubscribe('mailed_notifications')

      expect(user.receives_mailed_notifications).to be_false
    end

    it "raises an exception when trying to unsubscribe from a non-existing mailing" do
      expect do
        user.user_notification.unsubscribe('pokemon_newsletter')
      end.to raise_error
    end

    it "returns true when unsubscribe was possible" do
      expect(user.receives_digest).to be_true
      return_value = user.user_notification.unsubscribe('digest')
      expect(return_value).to be_true
    end

    it "returns false when already unsubscribed" do
      user.user_notification.unsubscribe('digest')
      return_value = user.user_notification.unsubscribe('digest')
      expect(return_value).to be_false
    end
  end
end
