require 'spec_helper'

class Blob < OurOhm ;end
class Foo < OurOhm ;end

describe Activity do
  let(:b1) { Blob.create }
  let(:b2) { Blob.create }
  let(:gu) { GraphUser.create }

  let(:gu2) { GraphUser.create }
  let(:gu3) { GraphUser.create }
  context "initially" do
    describe ".for" do
      it "should be empty" do
        Activity.for(b1).to_a.should =~ []
        Activity.for(b2).to_a.should =~ []
        Activity.for(gu).to_a.should =~ []
      end
    end
  end

  context "after creating one activity" do
    before do
      a = Activity.create(
             :user => gu,
             :action => :foo,
             :subject => b1,
             :object => b2
           )
      @activity = Activity[a.id]
    end
    it {@activity.user.should == gu }
    it {@activity.subject.should == b1 }
    it {@activity.object.should == b2 }
    describe "should be retrievable with Activity.for" do
      it {Activity.for(gu).to_a.should =~ [@activity] }
      it "should give no results for an object without activities" do
        Activity.for(Foo.create).to_a.should =~ []
      end
      it {Activity.for(b1).to_a.should =~ [@activity] }
      it {Activity.for(b2).to_a.should =~ [@activity] }
    end
  end

  context "when dealing with activities on graphusers" do
    before do
      a = Activity.create(
             :user => gu,
             :action => :foo,
             :subject => gu2,
             :object => gu3
           )
      @activity = Activity[a.id]
    end
    it {@activity.user.should == gu }
    it {@activity.subject.should == gu2 }
    it {@activity.object.should == gu3 }
    describe "should be retrievable with Activity.for" do
      it {Activity.for(gu).to_a.should =~ [@activity] }
      it "should give no results for an object without activities" do
        Activity.for(Foo.create).to_a.should =~ []
      end
      it {Activity.for(gu2).to_a.should =~ [@activity] }
      it {Activity.for(gu3).to_a.should =~ [@activity] }
    end
  end

  describe "still_valid?" do
    before do
      @a = Activity.create(
             :user => gu,
             :action => :foo,
             :subject => gu2,
             :object => gu3
           )
    end

    it "should be valid for valid activity" do
      @a.should be_still_valid
    end

    it "should not be valid if the user is deleted" do
      gu.delete
      @a.should_not be_still_valid
    end

    it "should not be valid if the subject is deleted" do
      gu2.delete
      @a.should_not be_still_valid
    end

    it "should not be valid if the object is deleted" do
      gu3.delete
      @a.should_not be_still_valid
    end

    it "should be valid when the user is not set" do
      @a = Activity.create(
             :action => :foo,
             :subject => gu2,
             :object => gu3
           )
      @a.should be_still_valid
    end

    it "should be valid when the subject is unset/not set" do
      @a.subject = nil
      @a.should be_still_valid
    end

    it "should be valid when the object is unset/not set" do
      @a.object = nil
      @a.should be_still_valid
    end

  end

  describe :to_hash_without_time do
    it "should return a hash without time" do
      hash = {user: gu, action: :does, subject: b1, object: b2}
      Activity.new(hash).to_hash_without_time.should == hash
    end

    it "should work when object is nil" do
      hash = {user: gu, action: :does, subject: b1}
      Activity.new(hash).to_hash_without_time.should == hash
    end

    it "should always return the action as a symbol" do
      hash =  {user: gu, action: "does", subject: b1}
      Activity.new(hash).to_hash_without_time.should == {user: gu, action: :does, subject: b1}
    end
  end

end
