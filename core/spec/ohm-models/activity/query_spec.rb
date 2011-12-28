require_relative '../../ohm_helper.rb'
require_relative '../../../app/ohm-models/activity.rb'

class Blob < OurOhm ;end
class Foo < OurOhm ;end
class GraphUser < OurOhm ;end

describe Activity::Query do
  let(:gu)  { GraphUser.create }
  let(:gu2) { GraphUser.create }
  let(:b1)  { Blob.create }
  let(:f1)  { Foo.create }

  describe ".where" do
    it "should return an empty list when given an empty query" do
      a = Activity.create user: gu, action: 'foo', object: b1, subject: f1
      Activity::Query.where([]).to_a.should == []
    end
    it "should call where_one with each element of the array" do
      Activity::Query.should_receive(:where_one).with(1).once
      Activity::Query.should_receive(:where_one).with(2).once
      Activity::Query.where([1,2])
    end
  end

  describe ".where_one" do
    it "should return all elements of a user when queried for it" do
      a = Activity.create user: gu, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(user: gu).to_a.should == [a]
    end
    it "should not return elements for a user without activity" do
      a = Activity.create user: gu, action: 'foo', object: b1, subject: f1
      Activity::Query.where_one(user: gu2).to_a.should == []
    end
  end

end