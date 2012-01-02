require_relative '../../ohm_helper.rb'
require_relative '../../../app/ohm-models/activity.rb'

class Blob < OurOhm ;end
class Foo < OurOhm ;end
class GraphUser < OurOhm ;end

describe Activity::Query do
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }
  let(:b1)  { Blob.create }
  let(:b2)  { Blob.create }
  let(:f1)  { Foo.create }
  let(:f2)  { Foo.create }

  describe ".where" do
    it "should return an empty list when given an empty query" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where([]).to_a.should == []
    end
    it "should call where_one with each element of the array" do
      Activity::Query.should_receive(:where_one).with(1).once
      Activity::Query.should_receive(:where_one).with(2).once
      Activity::Query.where([1,2])
    end
  end

  describe ".where_one" do
    it "should return an empty list for an empty query" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      a = Activity.create user: gu2, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one({}).to_a.should == []
    end

    it "should return all elements of a user when queried for it" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(user: gu1).to_a.should == [a]
    end

    it "should not return elements for a user without activity" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(user: gu2).to_a.should == []
    end

    it "should return all elements of a subject when queried for it" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(subject: f1).to_a.should == [a]
    end

    it "should not return elements for a subject without activity" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(subject: f2).to_a.should == []
    end

    it "should return all elements of a object when queried for it" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(object: b1).to_a.should == [a]
    end

    it "should not return elements for a object without activity" do
      a = Activity.create user: gu1, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(object: b2).to_a.should == []
    end

    it "should return all elements for an action when queried for it" do
      a = Activity.create user: gu1, action: :foo, object: b1, subject: f1
      Activity::Query.where_one(action: :foo).to_a.should == [a]
    end

    it "should not return elements for an non-existing action" do
      a = Activity.create user: gu1, action: :foo, object: b1, subject: f1
      Activity::Query.where_one(action: :bar).to_a.should == []
    end

    it "should only find activities which match all queries" do
      a1 = Activity.create user: gu1, action: :foo, object: b1, subject: f1
      a2 = Activity.create user: gu1, action: :foo, object: b2, subject: f1
      a3 = Activity.create user: gu1, action: :foo, object: b1, subject: f2
      a4 = Activity.create user: gu2, action: :foo, object: b1, subject: f1
      a5 = Activity.create user: gu2, action: :foo, object: b2, subject: f1
      a6 = Activity.create user: gu2, action: :foo, object: b1, subject: f2

      Activity::Query.where_one(user:   gu1, action: :foo).to_a.should =~ [a1,a2,a3]
      Activity::Query.where_one(subject: f1, action: :foo).to_a.should =~ [a1,a2,a4,a5]
      Activity::Query.where_one(object:  b1, action: :foo).to_a.should =~ [a1,a3,a4,a6]

      Activity::Query.where_one(user:   gu1, action: :bar).to_a.should =~ []
      Activity::Query.where_one(subject: f1, action: :bar).to_a.should =~ []
      Activity::Query.where_one(object:  f2, action: :bar).to_a.should =~ []

      Activity::Query.where_one(user:   gu1, object: b1).to_a.should =~ [a1,a3]
      Activity::Query.where_one(user:   gu1, subject: f1).to_a.should =~ [a1,a2]
    end

    it "should find an activity with a certain action when searched for with a string" do
      a = Activity.create user: gu1, action: :foo, subject: f1
      Activity::Query.where_one(subject: f1, action: "foo").to_a.should == [a]
    end

  end

end