require 'spec_helper'

describe UserNotification do
  describe '#unsubscribe' do
    let(:user) { create :full_user, :confirmed, receives_digest: true, receives_mailed_notifications: true }

    it "unsubscribes you from a digest mailing" do
      user.user_notification.unsubscribe('digest')

      expect(user.user_notification.can_receive?('digest')).to be_false
    end

    it "unsubscribes you persisted from a digest mailing" do
      user.user_notification.unsubscribe('digest')

      refetched_user = User.find(user.id)

      expect(refetched_user.user_notification.can_receive?('digest')).to be_false
    end

    it "unsubscribes you from a mailed_notifications mailing" do
      user.user_notification.unsubscribe('mailed_notifications')

      expect(user.receives_mailed_notifications).to be_false
    end

    it "raises an exception when trying to unsubscribe from a non-existing mailing" do
      expect do
        user.user_notification.unsubscribe('pokemon_newsletter')
      end.to raise_error
    end

    it "returns true when unsubscribe was possible" do
      return_value = user.user_notification.unsubscribe('digest')
      expect(return_value).to be_true
    end

    it "returns false when already unsubscribed" do
      user.user_notification.unsubscribe('digest')
      return_value = user.user_notification.unsubscribe('digest')
      expect(return_value).to be_false
    end

    it "unsubscribes from all types if you pass in all" do
      user.user_notification.unsubscribe('all')

      subscribed_digest =
        user.user_notification.unsubscribe('digest')
      subscribed_mailed_notifications =
        user.user_notification.unsubscribe('mailed_notifications')

      expect(subscribed_digest).to be_false
      expect(subscribed_mailed_notifications).to be_false
    end
  end

  describe '#subscribe' do
    let(:user) { create :full_user, :confirmed, receives_digest: false, receives_mailed_notifications: false }

    it "subscribes you to a digest mailing" do
      expect(user.user_notification.can_receive?('digest')).to be_false

      user.user_notification.subscribe('digest')

      expect(user.user_notification.can_receive?('digest')).to be_true
    end

    it "subscribes you persisted to a digest mailing" do
      expect(user.user_notification.can_receive?('digest')).to be_false

      user.user_notification.subscribe('digest')

      refetched_user = User.find(user.id)

      expect(refetched_user.user_notification.can_receive?('digest')).to be_true
    end

    it "raises an exception when trying to subscribe to a non-existing mailing" do
      expect do
        user.user_notification.subscribe('pokemon_newsletter')
      end.to raise_error
    end

    it "returns true when subscribe was possible" do
      return_value = user.user_notification.subscribe('digest')
      expect(return_value).to be_true
    end

    it "returns false when already subscribed" do
      user.user_notification.subscribe('digest')
      return_value = user.user_notification.subscribe('digest')
      expect(return_value).to be_false
    end
  end

  describe '#can_receive?' do
    it 'returns false if a user is not confirmed' do
      unconfirmed_user = create :full_user, receives_digest: true, receives_mailed_notifications: true

      expect(unconfirmed_user.user_notification.can_receive?('digest')).to be_false
    end
  end

  describe ".users_receiving" do
    it "only returns confirmed users that have selected to receive digests" do
      unconfirmed_user = create :user, receives_digest: true
      active_unconfirmed_user = create :full_user, confirmed_at: nil, receives_digest: true
      confirmed_user_without_digest = create :user, :confirmed, receives_digest: false
      confirmed_user = create :user, :confirmed, receives_digest: true

      digest_users = UserNotification.users_receiving('digest')

      expect(digest_users).to eq [confirmed_user]
    end
  end
end
