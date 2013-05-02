require 'spec_helper'

describe User do

  subject {create :user}
  let(:nonnda_subject) {create :user, agrees_tos: false}

  let(:fact) {create :fact}
  let(:child1) {create :fact}

  context "Initially" do
    it {subject.graph_user.should == subject.graph_user }
    it "should not be an Admin" do
      subject.admin.should == false
    end
    it "should not be approved" do
      subject.approved.should == false
    end

    it "should not have a tour step" do
      # Note: no default should be set for the tour step
      # rather set the first step in start_the_tour_path
      expect(subject.seen_tour_step).to eq nil
    end
  end

  it "should have a GraphUser" do
    subject.graph_user.should be_a(GraphUser)
  end

  describe "last_read_activities_on" do
    it "should set the correct DateTime in the database" do
      datetime = DateTime.parse("2001-02-03T04:05:06+01:00")

      subject.last_read_activities_on = datetime

      subject.save

      subject.last_read_activities_on.should == datetime
    end
  end

  describe :assign_attributes do
    let (:valid_attributes) {
      {
        username: "TestUser",
        first_name: "Test",
        last_name: "User",
        email: "test@emial.nl",
        password: "test123"
      }
    }

    it "should not fail when trying assign a username" do
      user = User.new
      user.assign_attributes(valid_attributes, as: :admin)

      user.confirmed_at = DateTime.now

      user.save.should == true
    end
  end

  describe :username do
    it "should respect the username's case" do
      user = build :user, username: "TestUser"
      user.save.should == true

      User.find(user.id).username.should == "TestUser"
    end

    it "should check uniqueness case insensitive" do
      user1 = create :user, username: "TestUser"
      user2 = build  :user, username: "testuser"
      user2.save.should be_false
    end
  end

  describe :to_param do
    it {subject.to_param.should == subject.username }
  end

  context "when agreeing the tos" do
    describe "when trying to agree without signing" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(false).should == false
        nonnda_subject.errors.keys.length.should == 1
        nonnda_subject.agrees_tos.should == false
      end
    end

    describe "when agreeing with signing" do
      it "should be allowed" do
        t = DateTime.now
        DateTime.stub!(:now).and_return(t)
        nonnda_subject.sign_tos(true).should == true
        nonnda_subject.agreed_tos_on.to_i.should == t.to_i
        nonnda_subject.errors.keys.length.should == 0
      end
    end

    describe "user signing the ToS" do
      it "correctly should persist to the database" do
        agrees_tos      = true

        nonnda_subject.sign_tos(agrees_tos)

        user = User.find(nonnda_subject.id)
        user.agrees_tos.should      == agrees_tos
      end
    end
  end

  describe ".find" do
    it "should work with numerical ids" do
      User.find(subject.id).should == subject
    end
    it "should work with usernames" do
      User.find_by(username: subject.username).should == subject
    end
  end

  describe '#first_name' do
    before do
      @u = build :user
    end

    it "cannot be empty" do
      @u.first_name = ""
      @u.valid?.should be_false
    end

    it "can be just one letter" do
      @u.first_name = "a"
      @u.valid?.should be_true
    end
  end

  describe '#last_name' do
    before do
      @u = build :user
    end
    
    it "cannot be empty" do
      @u.last_name = ""
      @u.valid?.should be_false
    end

    it "can be just one letter" do
      @u.last_name = "a"
      @u.valid?.should be_true
    end
  end

  describe :to_json do
    before do
      @json = subject.to_json
    end
    it "should not contain a password" do
      @json.should_not include(subject.encrypted_password)
    end
    [
      :admin, :agrees_tos, :'confirmation_sent_at', :confirmation_token,
      :confirmed_at, :current_sign_in_at, :current_sign_in_ip, :encrypted_password,
      :last_sign_in_at, :last_sign_in_ip, :remember_created_at, :reset_password_token,
      :sign_in_count, :agreed_tos_on, :agrees_tos_name
    ].map{|x| x.to_s}.each do |field|
      it "should not contain other sensitive information: #{field}" do
        @json.should_not include(field)
      end
    end
  end

  describe 'forbidden names' do
    before do
      @u = build :user
    end
    it "should be possible to choose GerardEkdom as name" do
      @u.username = "GerardEkdom"
      @u.valid?.should be_true
    end
    it "should not be possible to choose 1 letter as name" do
      @u.username = "a"
      @u.valid?.should be_false
    end
    [:users,:facts,:site, :templates, :search, :system, :tos, :pages, :privacy, :admin, :factlink].each do |name|
      it "should not be possible to choose #{name} as name" do
        @u.username = name.to_s
        @u.valid?.should be_false
      end
    end
  end

  describe "welcome_instructions" do

    it "sends a welcome email" do
      subject.send_welcome_instructions
      ActionMailer::Base.deliveries.last.to.should == [subject.email]
    end

    it "#send_welcome_instructions should be called once" do
      subject.should_receive(:send_welcome_instructions).once
      subject.approved = true
      subject.save
    end

  end

  describe ".approved" do
    it "only returns approved users" do
      expect(User.approved.selector).to eq({"approved" => true})
    end
  end

  describe ".active" do
    it "only returns approved, confirmed, and TOS-signed users" do
      expect(User.active.selector).to eq({"approved"=>true, "confirmed_at"=>{"$ne"=>nil}, "agrees_tos"=>true})
    end
  end

  describe "#valid_username_and_email?" do
    it "should validate normal username and email address fine" do
      user = User.new
      user.username = "some_username"
      user.email = "some@email.com"

      result = user.valid_username_and_email?
      errors = user.errors

      expect(result).to be_true
      expect(errors.size).to eq 0
    end

    it "should keep an error if the username is invalid" do
      user = User.new
      user.username = "a"
      user.email = "some@email.com"

      result = user.valid_username_and_email?
      errors = user.errors

      expect(result).to be_false
      expect(errors.size).to eq 1
      expect(errors[:username].any?).to be_true
    end

    it "should keep an error if the email is invalid" do
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

  describe '#reset_password_and_set_other_attributes_by_token' do
    before do
      stub_const 'UserMailer', Class.new
      UserMailer.stub welcome_instructions: mock(deliver: nil)
    end

    let(:user) do
      user = User.new
      user.username = 'username'
      user.email = 'example@example.org'
      user.save validate: false
      user.send_welcome_instructions
      user
    end

    it 'resets the password' do
      attributes = {
        reset_password_token: user.reset_password_token,
        password: 'example',
        password_confirmation: 'example'
      }

      User.reset_password_and_set_other_attributes_by_token(attributes)

      updated_user = User.find(user.id)
      expect(updated_user.valid_password?(attributes[:password])).to be_true
    end
  end
end
