require "spec_helper"

describe 'activity queries' do
  include RedisSupport
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }

  describe ".fact" do
    it "should return creation activity" do
      f1 = create :fact, created_by: gu1
      f1.interactions.map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end

    it "should return only creation activity on the fact queried" do
      f1 = create :fact, created_by: gu1
      f2 = create :fact, created_by: gu1
      f3 = create :fact, created_by: gu1
      f1.interactions.map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end

  end

  describe ".channel" do
    it "should return activity for when a channel followed this channel" do
      ch1 = create :channel
      ch2 = create :channel
      ch1.add_channel(ch2)
      ch2.activities.map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
      ]
    end

    it "should return activity for all users following a channel of User1 when User1 creates a new channel" do
      ch1 = create :channel, created_by: gu1
      ch2 = create :channel, created_by: gu2

      ch1.add_channel(ch2)
      ch3 = create :channel, created_by: gu2

      # Channel should not be empty
      f1 = create :fact
      ch3.add_fact f1

      gu1.stream_activities.map(&:to_hash_without_time).should == [
        {user: gu2, action: :created_channel, subject: ch3}
      ]
    end

    [:supporting, :weakening].each do |type|
      it "should return activities about facts which have received extra #{type} evidence" do
        ch1 = create :channel
        f1 = create :fact
        f2 = create :fact
        ch1.add_fact f1
        f1.add_evidence type, f2, gu1

        @nr = number_of_commands_on Ohm.redis do
          @activities = ch1.activities.map(&:to_hash_without_time)
        end
        @nr.should < 25
        @activities.should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end
    end
  end

  describe ".user" do
    it "should return notification when a user follows your channel" do
      ch1 = create :channel
      ch2 = create :channel

      ch1.add_channel(ch2)
      ch2.created_by.notifications.map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
      ]
    end

    it "should return stream activity when a user follows your channel" do
      ch1 = create :channel
      ch2 = create :channel

      ch1.add_channel(ch2)
      ch2.created_by.stream_activities.map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
      ]
    end

    it "should only return other users activities, not User his own activities" do
      f1 = create :fact
      f1.created_by.stream_activities.key.del # delete other activities

      f1.add_opinion(:believes, gu1)
      f1.add_opinion(:disbelieves, f1.created_by)

      f1.created_by.stream_activities.map(&:to_hash_without_time).should == [
        {user: gu1, action: :believes, subject: f1},
      ]
    end

    it "should return activity when a user adds a Fact to your channel" do
      f = create :fact, created_by: gu1
      f.created_by.stream_activities.key.del # delete other activities

      ch = create :channel, created_by: gu2
      ch.add_fact(f)

      notification = gu1.stream_activities.map(&:to_hash_without_time).should == [
        {:user => gu2, :action => :added_fact_to_channel, :subject => f, :object => ch}
      ]
    end

    it "should return a :added_first_factlink activity when the users' first factlink is created" do
      f1 = create :fact, created_by: gu1

      gu1.stream_activities.map(&:to_hash_without_time).should == [
        {user: gu1, action: :added_first_factlink, subject: f1}
      ]
    end

    [:supporting, :weakening].each do |type|
      it "should return activity when a users adds #{type} evidence to a fact that you created" do
        f1 = create :fact
        f2 = create :fact
        f1.add_evidence type, f2, gu1
        f1.created_by.notifications.map(&:to_hash_without_time).should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end
      it "should return activity when a users adds #{type} evidence to a fact that you believed" do
        f1 = create :fact
        f1.add_opinion(:believes, gu1)
        f2 = create :fact
        f1.add_evidence type, f2, gu2
        gu1.notifications.map(&:to_hash_without_time).should == [
          {user: gu2, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end

    end
    [:believes, :doubts, :disbelieves].each do |opinion|
      it "should return activity when a user opinionates a fact of the user" do
        f1 = create :fact
        f1.created_by.stream_activities.key.del # delete other activities

        f1.add_opinion(opinion, gu1)

        f1.created_by.stream_activities.map(&:to_hash_without_time).should == [
            {user: gu1, action: opinion, subject: f1}
        ]
      end
    end
    it "should return an activity when a user accepts its invitation" do
      inviter = create :user

      u = create :user
      u.invited_by = inviter
      u.save

      u.approve_invited_user_and_create_activity

      u.graph_user.notifications.map(&:to_hash_without_time).should == [
        {user: inviter.graph_user, action: :invites, subject: u.graph_user}
      ]
    end
  end
  describe :added_facts do
    it 'should contain the last added fact' do
      ch = create :channel
      f = create :fact
      ch.add_fact f
      ch.added_facts.map(&:to_hash_without_time).should == [
        {user: ch.created_by, action: :added_fact_to_channel, subject: f, object: ch}
      ]
    end
  end

  describe :messages do

    it "creates a notification for the receiver" do
      f  = create(:fact)
      u1 = create(:user)
      u2 = create(:user)

      CreateConversationWithMessageInteractor.perform [u1.username, u2.username], u1.username, 'this is a message', current_user: u1

      u1.graph_user.notifications.map(&:to_hash_without_time).should == []
      u2.graph_user.notifications.map(&:to_hash_without_time).should == [
        {user: u1.graph_user, action: :created_conversation, subject: Conversation.last }
      ]
    end

  end

end
