require 'spec_helper'

describe User do

  subject {FactoryGirl.create :user}
  let(:nonnda_subject) {FactoryGirl.create :user, agrees_tos: false}

  let(:fact) {FactoryGirl.create :fact}
  let(:child1) {FactoryGirl.create :fact}

  context "Initially" do
    it {subject.graph_user.facts.to_a.should == []}
    it {subject.graph_user.should == subject.graph_user }
    it "should not be an Admin" do
      subject.admin.should == false
    end
  end

  it "should have one active factlink after adding believe" do
    child1.add_opinion(:beliefs, subject.graph_user)
    subject.graph_user.facts.size == 1
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

  describe :to_param do
    it {subject.to_param.should == subject.username }
  end

  context "when agreeing the tos" do
    describe "when trying to agree without signing, without a name" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(false, '').should == false
        nonnda_subject.errors.full_messages.length.should == 2
        nonnda_subject.agrees_tos_name.should == ''
        nonnda_subject.agrees_tos.should == false
      end
    end

    describe "when trying to agree without signing" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(false, 'Sjaak').should == false
        nonnda_subject.errors.keys.length.should == 1
        nonnda_subject.agrees_tos_name.should == ''
        nonnda_subject.agrees_tos.should == false
      end
    end
    describe "when trying to agree without a name" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(true, '').should == false
        nonnda_subject.errors.keys.length.should == 1
        nonnda_subject.agrees_tos_name.should == ''
        nonnda_subject.agrees_tos.should == false
      end
    end
    describe "when agreeing with a name" do
      it "should be allowed" do
        t = DateTime.now
        DateTime.stub!(:now).and_return(t)
        nonnda_subject.sign_tos(true, 'Sjaak').should == true
        nonnda_subject.agrees_tos_name.should == 'Sjaak'
        nonnda_subject.agrees_tos.should == true
        nonnda_subject.agreed_tos_on.to_i.should == t.to_i
        nonnda_subject.errors.keys.length.should == 0
      end
    end

    describe "user signing the ToS" do
      it "correctly should persist to the database" do
        agrees_tos      = true
        agrees_tos_name = "Tom"

        nonnda_subject.sign_tos(agrees_tos, agrees_tos_name)

        user = User.find(nonnda_subject.id)
        user.agrees_tos.should      == agrees_tos
        user.agrees_tos_name.should == agrees_tos_name
      end
    end
  end

  describe ".find" do
    it "should work with numerical ids" do
      User.find(subject.id).should == subject
    end
    it "should work with usernames" do
      User.find(subject.username).should == subject
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
end
