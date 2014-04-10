require 'spec_helper'

describe Backend::Notifications do
  describe '#unsubscribe' do
    let(:user) { create :user, :confirmed, receives_digest: true, receives_mailed_notifications: true }

    it "unsubscribes you from a digest mailing" do
      Backend::Notifications.unsubscribe(user: user, type: 'digest')

      expect(Backend::Notifications.can_receive?(user: user, type: 'digest')).to be_false
    end

    it "unsubscribes you persisted from a digest mailing" do
      Backend::Notifications.unsubscribe(user: user, type: 'digest')

      refetched_user = User.find(user.id)

      expect(Backend::Notifications.can_receive?(user: refetched_user, type: 'digest')).to be_false
    end

    it "unsubscribes you from a mailed_notifications mailing" do
      Backend::Notifications.unsubscribe(user: user, type: 'mailed_notifications')

      expect(user.receives_mailed_notifications).to be_false
    end

    it "raises an exception when trying to unsubscribe from a non-existing mailing" do
      expect do
        Backend::Notifications.unsubscribe(user: user, type: 'pokemon_newsletter')
      end.to raise_error
    end

    it "returns true when unsubscribe was possible" do
      return_value = Backend::Notifications.unsubscribe(user: user, type: 'digest')
      expect(return_value).to be_true
    end

    it "returns false when already unsubscribed" do
      Backend::Notifications.unsubscribe(user: user, type: 'digest')
      return_value = Backend::Notifications.unsubscribe(user: user, type: 'digest')
      expect(return_value).to be_false
    end

    it "unsubscribes from all types if you pass in all" do
      Backend::Notifications.unsubscribe(user: user, type: 'all')

      subscribed_digest =
        Backend::Notifications.unsubscribe(user: user, type: 'digest')
      subscribed_mailed_notifications =
        Backend::Notifications.unsubscribe(user: user, type: 'mailed_notifications')

      expect(subscribed_digest).to be_false
      expect(subscribed_mailed_notifications).to be_false
    end
  end

  describe '#subscribe' do
    let(:user) { create :user, :confirmed, receives_digest: false, receives_mailed_notifications: false }

    it "subscribes you to a digest mailing" do
      expect(Backend::Notifications.can_receive?(user: user, type: 'digest')).to be_false

      Backend::Notifications.subscribe(user: user, type: 'digest')

      expect(Backend::Notifications.can_receive?(user: user, type: 'digest')).to be_true
    end

    it "subscribes you persisted to a digest mailing" do
      expect(Backend::Notifications.can_receive?(user: user, type: 'digest')).to be_false

      Backend::Notifications.subscribe(user: user, type: 'digest')

      refetched_user = User.find(user.id)

      expect(Backend::Notifications.can_receive?(user: refetched_user, type: 'digest')).to be_true
    end

    it "raises an exception when trying to subscribe to a non-existing mailing" do
      expect do
        Backend::Notifications.subscribe(user: user, type: 'pokemon_newsletter')
      end.to raise_error
    end

    it "returns true when subscribe was possible" do
      return_value = Backend::Notifications.subscribe(user: user, type: 'digest')
      expect(return_value).to be_true
    end

    it "returns false when already subscribed" do
      Backend::Notifications.subscribe(user: user, type: 'digest')
      return_value = Backend::Notifications.subscribe(user: user, type: 'digest')
      expect(return_value).to be_false
    end
  end

  describe '#can_receive?' do
    it 'returns false if a user is not confirmed' do
      unconfirmed_user = create :user, receives_digest: true, receives_mailed_notifications: true

      expect(Backend::Notifications.can_receive?(user: unconfirmed_user, type: 'digest')).to be_false
    end
  end

  describe ".users_receiving" do
    it "only returns confirmed users that have selected to receive digests" do
      unconfirmed_user = create :user, receives_digest: true
      active_unconfirmed_user = create :user, receives_digest: true
      confirmed_user_without_digest = create :user, :confirmed, receives_digest: false
      confirmed_user = create :user, :confirmed, receives_digest: true

      digest_users = Backend::Notifications.users_receiving(type: 'digest')

      expect(digest_users).to eq [confirmed_user]
    end
  end
end
