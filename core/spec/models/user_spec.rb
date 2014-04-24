require 'spec_helper'

describe User do

  subject(:user) { create :user }

  context "Initially" do
    it "isn't admin" do
      expect(subject.admin).to be_false
    end
  end

  describe :assign_attributes do
    let (:valid_attributes) do
      {
        username: "TestUser",
        full_name: "Test User",
        email: "test@emial.nl",
        password: "test123"
      }
    end

    it "can assign a username" do
      user = User.new
      user.assign_attributes(valid_attributes, as: :admin)

      user.confirmed_at = DateTime.now

      expect(user.save).to be_true
    end
  end

  describe :username do
    it "checks uniqueness case insensitively" do
      create :user, username: "TestUser"
      user2 = build  :user, username: "testuser"
      expect(user2.save).to be_false
    end
  end

  describe '#full_name' do
    let(:new_user) { build :user }

    it "cannot be empty" do
      new_user.full_name = ""
      expect(new_user.valid?).to be_false
    end

    it "can be just one letter" do
      new_user.full_name = "a"
      expect(new_user.valid?).to be_true
    end
  end

  describe 'forbidden names' do
    let(:new_user) { build :user }
    it "can have GerardEkdom as name" do
      new_user.username = "GerardEkdom"
      expect(new_user.valid?).to be_true
    end
    it "cannot have 1 letter as name" do
      new_user.username = "a"
      expect(new_user.valid?).to be_false
    end
    [:users,:facts,:site, :templates, :search, :system, :tos, :pages, :privacy, :admin, :factlink].each do |name|
      it "cannot choose #{name} as name" do
        new_user.username = name.to_s
        expect(new_user.valid?).to be_false
      end
    end
  end

  # also describes .hidden?
  describe '.active?' do
    context "initial user" do
      subject(:user) { create :user }
      it { expect(user).to     be_active }
      it { expect(user).to_not be_hidden }
    end
    context "deleted user" do
      let(:deleted_user) { create :user, deleted: true }
      it { expect(deleted_user).to_not be_active }
      it { expect(deleted_user).to     be_hidden }
    end
  end

  describe 'scopes' do
    describe ".active" do
      it "doesn't return deleted users" do
        user = create :user, deleted: true

        active_users = User.active.load
        expect(active_users).to be_empty
      end
    end
  end

  describe "#notification_settings_edit_token" do
    let (:valid_attributes) do
      {
        username: "TestUser",
        full_name: "Test User",
        email: "test@example.org",
        password: "test123"
      }
    end

    it "should be set on user creation" do
      user = User.create! valid_attributes, as: :admin

      token = user.notification_settings_edit_token

      expect(token).to match /\A\w{4,}\Z/
    end

    it "generates a random token" do
      user1 = User.create!(valid_attributes, as: :admin)
      user2 = User.create!(valid_attributes.merge({username: 'Hello', email: 'hello@example.org'}), as: :admin)

      token1 = user1.notification_settings_edit_token
      token2 = user2.notification_settings_edit_token

      expect(token1).to_not eq token2
    end

    it "should not reset on account update without password change" do
      user1 = User.create! valid_attributes, as: :admin

      old_token = user1.notification_settings_edit_token
      user1.update_attribute :email, 'pietje@example.org'
      new_token = user1.notification_settings_edit_token

      expect(new_token).to eq old_token
    end

    it "should reset on password change" do
      user1 = User.create! valid_attributes, as: :admin

      old_token = user1.notification_settings_edit_token
      user1.reset_password! 'hellohello', 'hellohello'
      new_token = user1.notification_settings_edit_token

      expect(new_token).to_not eq old_token
    end
  end

  describe '#social_account' do
    it 'returns a social account which can be saved' do
      facebook_account = user.social_account('facebook')
      facebook_account.update_omniauth_obj!({'uid' => '10', 'provider' => 'facebook'})
      facebook_account.save!

      expect(User.first.social_account('facebook').uid).to eq '10'
    end
  end
end
