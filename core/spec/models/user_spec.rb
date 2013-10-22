require 'spec_helper'

describe User do

  subject(:user) { create :user}
  let(:nonnda_subject) {create :user, agrees_tos: false}

  context "Initially" do
    it "isn't admin" do
      expect(subject.admin).to be_false
    end

    it "has no tour step" do
      # Note: no default should be set for the tour step
      # rather set the first step in start_the_tour_path
      expect(subject.seen_tour_step).to eq nil
    end
    it "has a GraphUser" do
      expect(subject.graph_user).to be_a(GraphUser)
    end
  end

  describe "last_read_activities_on" do
    it "sets the correct DateTime in the database" do
      datetime = DateTime.parse("2001-02-03T04:05:06+01:00")

      subject.last_read_activities_on = datetime
      subject.save

      expect(subject.last_read_activities_on).to eq datetime
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
    it "respects the username's case" do
      user = build :user, username: "TestUser"
      user.save!

      retrieved_username = User.find(user.id).username
      expect(retrieved_username).to eq "TestUser"
    end

    it "checks uniqueness case insensitively" do
      user1 = create :user, username: "TestUser"
      user2 = build  :user, username: "testuser"
      expect(user2.save).to be_false
    end
  end

  describe :to_param do
    it {expect(subject.to_param).to eq subject.username }
  end

  context "when agreeing the tos" do
    describe "when trying to agree without signing" do
      it "isn't allowed" do
        expect(nonnda_subject.sign_tos(false)).to be_false
        expect(nonnda_subject.errors.keys.length).to eq 1
        expect(nonnda_subject.agrees_tos).to be_false
      end
    end

    describe "when agreeing with signing" do
      it "is allowed" do
        t = DateTime.now
        DateTime.stub(:now).and_return(t)
        expect(nonnda_subject.sign_tos(true)).to eq true
        expect(nonnda_subject.agreed_tos_on.to_i).to eq t.to_i
        expect(nonnda_subject.errors.keys.length).to eq 0
      end
    end

    describe "user signing the ToS" do
      it "correctly persists to the database" do
        agrees_tos      = true

        nonnda_subject.sign_tos(agrees_tos)

        user = User.find(nonnda_subject.id)
        expect(user.agrees_tos).to eq agrees_tos
      end
    end
  end

  describe ".find" do
    it "works with numerical ids" do
      expect(User.find(subject.id)).to eq subject
    end
    it "works with usernames" do
      expect(User.find(subject.username)).to eq subject
    end
  end

  describe '#full_name' do
    let(:new_user){ build :user }

    it "cannot be empty" do
      new_user.full_name = ""
      expect(new_user.valid?).to be_false
    end

    it "can be just one letter" do
      new_user.full_name = "a"
      expect(new_user.valid?).to be_true
    end
  end

  describe :to_json do
    let(:json){ subject.to_json }
    it "contains no password" do
      expect(json).to_not include(subject.encrypted_password)
    end
    [
      :admin, :agrees_tos, :'confirmation_sent_at', :confirmation_token,
      :confirmed_at, :current_sign_in_at, :current_sign_in_ip, :encrypted_password,
      :last_sign_in_at, :last_sign_in_ip, :remember_created_at, :reset_password_token,
      :sign_in_count, :agreed_tos_on, :agrees_tos_name
    ].map{|x| x.to_s}.each do |field|
      it "does not contain other sensitive information: #{field}" do
        expect(json).to_not include(field)
      end
    end
  end

  describe 'forbidden names' do
    let(:new_user){ build :user }
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
      let(:initial_user) { create :user }
      it { expect(initial_user).to_not be_active }
      it { expect(initial_user).to     be_hidden }
    end
    context "user who is set up" do
      let(:set_up_user) { create :user, :set_up }
      it { expect(set_up_user).to_not be_active }
      it { expect(set_up_user).to     be_hidden }
    end
    context "user who signed the tos, but somehow not set up" do
      subject(:active_user) { create :user, :agrees_tos }
      it { expect(active_user).to_not be_active }
      it { expect(active_user).to     be_hidden }
    end
    context "set up user who signed the tos" do
      subject(:active_user) { create :user, :agrees_tos, :set_up }
      it { expect(active_user).to     be_active }
      it { expect(active_user).to_not be_hidden }
    end
    context "deleted user" do
      let(:deleted_user) do
        create(:user, :agrees_tos).tap do |user|
          Pavlov.command('users/mark_as_deleted', user:user)
        end
      end
      it { expect(deleted_user).to_not be_active }
      it { expect(deleted_user).to     be_hidden }
    end
    context "suspended user" do
      subject(:suspended_user) { create :full_user, suspended: true }
      it { expect(suspended_user).to_not be_active }
      it { expect(suspended_user).to     be_hidden }
    end
  end

  describe 'scopes' do
    describe ".active" do
      it "only returns set up, and TOS-signed users" do
        inactive_user = create :user
        active_user = create :user, :set_up, :agrees_tos

        active_users = User.active.all
        expect(active_users).to eq [active_user]
      end

      it "doesn't return deleted users" do
        user = create :user, :agrees_tos

        Pavlov.command('users/mark_as_deleted', user:user)

        active_users = User.active.all
        expect(active_users).to be_empty
      end
    end

    describe ".seen_the_tour" do
      it "only returns set up, TOS-signed users that have seen the tour" do
        inactive_user = create :user
        active_user = create :user, :set_up, :agrees_tos
        seen_the_tour_user = create :user, :set_up, :agrees_tos, :seen_the_tour

        seen_tour_users = User.seen_the_tour.all

        expect(seen_tour_users.all).to eq [seen_the_tour_user]
      end
    end
  end

  describe "#valid_username_and_email?" do
    it "validates normal username and email address fine" do
      user = User.new
      user.username = "some_username"
      user.email = "some@email.com"

      result = user.valid_username_and_email?
      errors = user.errors

      expect(result).to be_true
      expect(errors.size).to eq 0
    end

    it "keeps an error if the username is invalid" do
      user = User.new
      user.username = "a"
      user.email = "some@email.com"

      result = user.valid_username_and_email?
      errors = user.errors

      expect(result).to be_false
      expect(errors.size).to eq 1
      expect(errors[:username].any?).to be_true
    end

    it "keeps an error if the email is invalid" do
      user = User.new
      user.username = "some_username"
      user.email = "a"

      result = user.valid_username_and_email?
      errors = user.errors

      expect(result).to be_false
      expect(errors.size).to eq 1
      expect(errors[:email].any?).to be_true
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

      token = user.user_notification.notification_settings_edit_token

      expect(token).to match /\A\w{4,}\Z/
    end

    it "generates a random token" do
      user1 = User.create!(valid_attributes, as: :admin)
      user2 = User.create!(valid_attributes.merge({username: 'Hello', email: 'hello@example.org'}), as: :admin)

      token1 = user1.user_notification.notification_settings_edit_token
      token2 = user2.user_notification.notification_settings_edit_token

      expect(token1).to_not eq token2
    end

    it "should not reset on account update without password change" do
      user1 = User.create! valid_attributes, as: :admin

      old_token = user1.user_notification.notification_settings_edit_token
      user1.update_attribute :email, 'pietje@example.org'
      new_token = user1.user_notification.notification_settings_edit_token

      expect(new_token).to eq old_token
    end

    it "should reset on password change" do
      user1 = User.create! valid_attributes, as: :admin

      old_token = user1.user_notification.notification_settings_edit_token
      user1.reset_password! 'hellohello', 'hellohello'
      new_token = user1.user_notification.notification_settings_edit_token

      expect(new_token).to_not eq old_token
    end
  end

  describe '#social_account' do
    it 'returns a social account which can be saved' do
      facebook_account = user.social_account('facebook')
      facebook_account.omniauth_obj = {uid: '10'}
      facebook_account.save!

      expect(User.first.social_account('facebook').omniauth_obj['uid']).to eq '10'
    end
  end
end
