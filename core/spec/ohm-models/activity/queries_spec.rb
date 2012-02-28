require "spec_helper"

describe Activity::For do
  include RedisSupport
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }

  describe ".fact" do
    it "should return creation activity" do
      f1 = create :fact, created_by: gu1
      Activity::For.fact(f1).map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end

    it "should return only creation activity on the fact queried" do
      f1 = create :fact, created_by: gu1
      f2 = create :fact, created_by: gu1
      f3 = create :fact, created_by: gu1
      Activity::For.fact(f1).map(&:to_hash_without_time).should == [
        {user: gu1, action: :created, subject: f1}
      ]
    end
  end

  describe ".channel" do
    it "should return activity for when a channel followed this channel" do
      ch1 = create :channel
      ch2 = create :channel
      ch1.add_channel(ch2)
      Activity::For.channel(ch2).map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
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
          @activities = Activity::For.channel(ch1).map(&:to_hash_without_time)
        end
        @nr.should < 25
        @activities.should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end
    end
  end

  describe ".user" do
    it "should return activity when a user follows your channel" do
      ch1 = create :channel
      ch2 = create :channel

      ch1.add_channel(ch2)
      Activity::For.user(ch2.created_by).map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
      ]
    end

    it "should only return other users activities, not User his own activities" do
      f1 = create :fact

      f1.add_opinion(:believes, gu1)
      f1.add_opinion(:disbelieves, f1.created_by)

      Activity::For.user(f1.created_by).map(&:to_hash_without_time).should == [
        {user: gu1, action: :believes, subject: f1},
      ]
    end

    [:supporting, :weakening].each do |type|
      it "should return activity when a users adds #{type} evidence to a fact that you created" do
        f1 = create :fact
        f2 = create :fact
        f1.add_evidence type, f2, gu1
        Activity::For.user(f1.created_by).map(&:to_hash_without_time).should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end
    end
    [:believes, :doubts, :disbelieves].each do |opinion|
      it "should return activity when a users opinionates a fact of the user" do
        f1 = create :fact
        f1.add_opinion(opinion, gu1)

        Activity::For.user(f1.created_by).map(&:to_hash_without_time).should == [
            {user: gu1, action: opinion, subject: f1}
        ]
      end
    end
  end
end
