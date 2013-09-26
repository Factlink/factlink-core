require 'spec_helper'

describe User do

  subject { create :user }
  let(:nonnda_subject) {create :user, agrees_tos: false}

  context "Initially" do
    it "isn't admin" do
      expect(subject.admin).to be_false
    end
    it "isn't approved" do
      expect(subject.approved).to be_false
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
        first_name: "Test",
        last_name: "User",
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

  describe '#first_name' do
    let(:new_user){ build :user }

    it "cannot be empty" do
      new_user.first_name = ""
      expect(new_user.valid?).to be_false
    end

    it "can be just one letter" do
      new_user.first_name = "a"
      expect(new_user.valid?).to be_true
    end
  end

  describe '#last_name' do
    let(:new_user){ build :user }

    it "cannot be empty" do
      new_user.last_name = ""
      expect(new_user.valid?).to be_false
    end

    it "can be just one letter" do
      new_user.last_name = "a"
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

  describe "welcome_instructions" do

    it "sends a welcome email" do
      subject.send_welcome_instructions
      last_recipients = ActionMailer::Base.deliveries.last.to
      expect(last_recipients).to eq [subject.email]
    end

    it "#send_welcome_instructions are called once" do
      expect(subject).to receive(:send_welcome_instructions).once
      subject.approved = true
      subject.save
    end

  end

  # also describes .hidden?
  describe '.active?' do
    context "new user" do
      let(:waiting_list_user) { create :user }
      it { expect(waiting_list_user).to_not be_active }
      it { expect(waiting_list_user).to     be_hidden }
    end
    context "just confirmed user" do
      let(:confirmed_user) { create :user, :confirmed }
      it { expect(confirmed_user).to_not be_active }
      it { expect(confirmed_user).to     be_hidden }
    end
    context "just approved user" do
      let(:approved_user) { create :user, :confirmed, :approved }
      it { expect(approved_user).to_not be_active }
      it { expect(approved_user).to     be_hidden }
    end
    context "unapproved (disapproved) user who signed the tos" do
      let(:approved_user) { create :user, :agrees_tos }
      it { expect(approved_user).to_not be_active }
      it { expect(approved_user).to     be_hidden }
    end
    context "confirmed, approved user who signed the tos" do
      subject(:active_user) { create :user, :approved, :confirmed, :agrees_tos }
      it { expect(active_user).to     be_active }
      it { expect(active_user).to_not be_hidden }
    end
    context "deleted user" do
      let(:deleted_user) do
        create(:user, :approved, :confirmed, :agrees_tos).tap do |user|
          user.deleted = true #TODO:PAVLOVify
          user.save!
        end
      end
      it { expect(deleted_user).to_not be_active }
      it { expect(deleted_user).to     be_hidden }
    end
  end

  describe 'scopes' do
    describe ".approved" do
      it "only returns approved users" do
        waiting_list_user = create :user
        approved_user = create :user, :approved
        approved_users = User.approved.all
        expect(approved_users).to include approved_user
        expect(approved_users).to_not include waiting_list_user
      end
    end

    describe ".active" do
      it "only returns approved, confirmed, and TOS-signed users" do
        waiting_list_user = create :user
        approved_user = create :user, :approved
        active_user = create :user, :approved, :confirmed, :agrees_tos

        active_users = User.active.all
        expect(active_users).to eq [active_user]
      end

      it "doesn't return deleted users" do
        user = create :user, :approved, :confirmed, :agrees_tos
        user.deleted = true #TODO:PAVLOVify
        user.save

        active_users = User.active.all
        expect(active_users).to be_empty
      end
    end

    describe ".seen_the_tour" do
      it "only returns approved, confirmed, TOS-signed users that have seen the tour" do
        waiting_list_user = create :user
        approved_user = create :user, :approved
        active_user = create :user, :approved, :confirmed, :agrees_tos
        seen_the_tour_user = create :user, :approved, :confirmed, :agrees_tos, :seen_the_tour

        seen_tour_users = User.seen_the_tour.all

        expect(seen_tour_users.all).to eq [seen_the_tour_user]
      end
    end

    describe ".receives_digest" do
      it "only returns approved, confirmed, TOS-signed users that have selected to receive digests" do
        waiting_list_user = create :user
        approved_user = create :user, :approved
        active_user = create :user, :approved, :confirmed, :agrees_tos
        active_user_without_digest = create :user, :approved, :confirmed, :agrees_tos
        active_user_without_digest.receives_digest = false
        active_user_without_digest.save!

        digest_users = User.receives_digest.all

        expect(digest_users).to eq [active_user]
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

end
