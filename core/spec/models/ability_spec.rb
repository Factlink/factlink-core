require 'spec_helper'
require "cancan/matchers"

describe Ability do

  # abilities
  subject                { Ability.new(user)}
  let(:anonymous)        { Ability.new}
  let(:admin)            { Ability.new admin_user}
  let(:nonnda)           { Ability.new nonnda_user}

  # users used as object
  let(:user)        {create :active_user}
  let(:other_user)  {create :active_user }
  let(:admin_user)  {create :active_user, :admin}
  let(:nonnda_user) {create :user, agrees_tos: false}

  describe "to manage a user" do
    context "as a normal user" do
      it {subject.should_not be_able_to :manage, User }
      it {subject.should_not be_able_to :configure, Ability::FactlinkWebapp }

      it {subject.should     be_able_to :show, user }
      it {subject.should     be_able_to :show, other_user }
      it {subject.should     be_able_to :update, user }

      it {subject.should     be_able_to :read_tos, user }
      it {subject.should_not be_able_to :sign_tos, user }

      it {subject.should     be_able_to :edit_settings, user }

      it {subject.should_not be_able_to :update, other_user }
      it {subject.should_not be_able_to :update, admin }
    end
    context "as a nonnda user" do
      it {nonnda.should_not be_able_to :manage, User }

      it {nonnda.should_not be_able_to :update, nonnda_user }
      it {nonnda.should     be_able_to :sign_tos, nonnda_user }
      it {nonnda.should     be_able_to :show, nonnda_user }
      it {nonnda.should_not be_able_to :show, User }
    end
    context "as an admin" do
      it {admin.should     be_able_to :manage, User }
      it {admin.should     be_able_to :configure, Ability::FactlinkWebapp }

      it {admin.should_not be_able_to :sign_tos, user }
      it {admin.should_not be_able_to :sign_tos, admin_user }

      it {admin.should_not be_able_to :edit_settings, user }
      it {admin.should be_able_to     :edit_settings, admin_user }
    end
    context "as an anonymous" do
      it {anonymous.should_not be_able_to :manage, User }

      it {anonymous.should_not be_able_to :sign_tos, nil }
      it {anonymous.should     be_able_to :read_tos, nil }
      it {anonymous.should_not be_able_to :show, User }
      it {anonymous.should_not be_able_to :edit_settings, user }
    end
  end

  describe "to get the fact count of a site" do
    context "as any user" do
      it {subject.should   be_able_to :get_fact_count, Site}
      it {anonymous.should be_able_to :get_fact_count, Site}
    end
  end

  describe "to manage channels" do

    let(:ch1) { create :channel, created_by: user.graph_user }
    let(:ch2) { create :channel, created_by: other_user.graph_user }

    it {subject.should be_able_to :index, Channel }
    it {subject.should be_able_to :create, Channel }

    describe "of my own" do
      it {subject.should be_able_to :update, ch1 }
      it {subject.should be_able_to :read, ch1 }
      it {subject.should be_able_to :create, ch1 }
    end

    describe "of someone else" do
      it {subject.should_not  be_able_to :update, ch2 }
      it {subject.should      be_able_to :read, ch2 }
      it {subject.should_not  be_able_to :create, ch2 }
    end

    describe "without logging in" do
      it {anonymous.should_not be_able_to :index, Channel }
      it {anonymous.should_not be_able_to :create, Channel }
      it {anonymous.should_not be_able_to :read, ch1 }
      it {anonymous.should_not be_able_to :update, ch1 }
      it {anonymous.should_not be_able_to :create, ch1 }
    end
  end

  describe "to manage facts" do
    let(:f1) { create :fact, created_by: user.graph_user }
    let(:f2) { create :fact, created_by: other_user.graph_user }

    it {subject.should be_able_to :index, Fact }
    it {subject.should be_able_to :create, Fact }

    describe "of my own" do
      it {subject.should_not be_able_to :update, f1 }
      it {subject.should     be_able_to :read, f1 }
      it {subject.should     be_able_to :opinionate, f1 }
      it {subject.should     be_able_to :add_evidence, f1 }
      it {subject.should     be_able_to :create, f1 }
      it {subject.should     be_able_to :share, f1 }
    end

    describe "of someone else" do
      it {subject.should_not  be_able_to :update, f2 }
      it {subject.should      be_able_to :read, f2 }
      it {subject.should      be_able_to :opinionate, f2 }
      it {subject.should      be_able_to :add_evidence, f2 }
      it {subject.should_not  be_able_to :create, f2 }
      it {subject.should      be_able_to :share, f2 }
    end

    describe "without logging in" do
      it {anonymous.should      be_able_to :index, Fact }
      it {anonymous.should      be_able_to :read, f1 }

      it {anonymous.should_not  be_able_to :create, Fact }
      it {anonymous.should_not  be_able_to :update, f1 }
      it {anonymous.should_not  be_able_to :opinionate, Fact }
      it {anonymous.should_not  be_able_to :add_evidence, f1 }
      it {anonymous.should_not  be_able_to :share, f1 }
    end
  end

  describe "to manage FactRelations" do
    let(:fr1) { create :fact_relation, created_by: user.graph_user }
    let(:fr2) { create :fact_relation, created_by: other_user.graph_user }

    describe "of my own" do
      it {subject.should be_able_to :read, fr1 }
      it {subject.should be_able_to :opinionate, fr1 }
      it {subject.should be_able_to :destroy, fr1 }
    end

    describe "of someone else" do
      it {subject.should      be_able_to :read, fr2 }
      it {subject.should      be_able_to :opinionate, fr2 }
      it {subject.should_not  be_able_to :destroy, fr2 }
    end

    describe "without logging in" do
      it {anonymous.should      be_able_to :read, fr1 }
      it {anonymous.should_not  be_able_to :opinionate, fr1 }
      it {anonymous.should_not  be_able_to :destroy, fr1 }
    end
  end

  describe "to manage Comments" do
    let(:c1) { create :comment, created_by: user }
    let(:c2) { create :comment, created_by: other_user }

    describe "of my own" do
      it {subject.should be_able_to :read, c1 }
    end

    describe "of someone else" do
      it {subject.should be_able_to :read, c2 }
    end

    describe "without logging in" do
      it {anonymous.should be_able_to :read, c1 }
    end
  end

  describe "accessing the admin area" do
    it "should only be allowed as admin" do
      admin.should         be_able_to :access, Ability::AdminArea
      subject.should_not   be_able_to :access, Ability::AdminArea
      anonymous.should_not be_able_to :access, Ability::AdminArea
    end
  end

  describe "accessing factlink" do
    it "should be allowed to users who signed the nda" do
      admin.should           be_able_to :access, Ability::FactlinkWebapp
      subject.should         be_able_to :access, Ability::FactlinkWebapp
      anonymous.should_not   be_able_to :access, Ability::FactlinkWebapp
      nonnda.should_not      be_able_to :access, Ability::FactlinkWebapp
    end
  end

  describe "seeing notifications" do
    it "should be possible to see and modify your own notifications" do
      subject.should be_able_to :see_activities, user
      subject.should be_able_to :mark_activities_as_read, user
    end

    it "should not be able to see and modify other people their notifications" do
      subject.should_not be_able_to :see_activities, other_user
      subject.should_not be_able_to :mark_activities_as_read, other_user
    end
  end

  describe "topics" do
    let(:topic) { create :topic }
    it "should be able to view a topic" do
      subject.should be_able_to :show, topic
    end
  end

  describe "to invite users" do
    it "should not be possible when you have no invites" do
      anonymous.should_not be_able_to :invite, User
      subject.should_not be_able_to :invite, User
      admin.should_not be_able_to :invite, User
    end
    describe "when you have invitations" do
      before do
        user.invitation_limit = 3
        admin_user.invitation_limit = 3
      end
      it "should be possible when you have no invites" do
        subject.should be_able_to :invite, User
        admin.should be_able_to :invite, User
      end
    end
  end

  describe "sharing" do
    it "should not be allowed by default" do
      admin.should_not     be_able_to :share_to, :twitter
      subject.should_not   be_able_to :share_to, :twitter
      nonnda.should_not    be_able_to :share_to, :twitter
      anonymous.should_not be_able_to :share_to, :twitter
      admin.should_not     be_able_to :share_to, :facebook
      subject.should_not   be_able_to :share_to, :facebook
      nonnda.should_not    be_able_to :share_to, :facebook
      anonymous.should_not be_able_to :share_to, :facebook
    end

    context "when connected to Twitter" do
      it "should be possible to share to Twitter" do
        user.identities['twitter'] = {}

        subject.should_not be_able_to :share_to, :twitter
      end
      context "with the feature toggle enabled" do
        it "should be possible to share to Twitter" do
          user.identities['twitter'] = {}
          user.features = [:share_to_twitter]

          Ability.new(user).should be_able_to :share_to, :twitter
        end
      end
    end

    context "when connected to Facebook" do
      it "should be possible to share to Facebook" do
        user.identities['facebook'] = {}

        subject.should_not be_able_to :share_to, :facebook
      end
      context "with the feature toggle enabled" do
        it "should be possible to share to Facebook" do
          user.identities['facebook'] = {}
          user.features = [:share_to_facebook]

          Ability.new(user).should be_able_to :share_to, :facebook
        end
      end
    end
  end

end
