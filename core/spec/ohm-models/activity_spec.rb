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

  describe "mailing activities" do
    context "creating an activity" do
      it "should invoke send_mail_for_activity" do
        interactor = double
        Interactors::SendMailForActivity.stub(:new)
            .and_return(interactor)
        interactor.should_receive(:call)

        Activity.create
      end
    end
  end

  context "after creating one activity" do
    before do
      Pavlov.stub(:old_interactor).with(:send_mail_for_activity, anything)
    end

    before :each do
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
    before :each do
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
    before :each do
      @a = Activity.create(
             :user => gu,
             :action => :foo,
             :subject => gu2,
             :object => gu3
           )
      @a=Activity[@a.id]
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
             :object => gu3,
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

  describe 'list management' do
    let(:activity) do Activity.create(
             :user => gu,
             :action => :foo,
             :subject => b1,
             :object => b2
           )
    end
    let (:activity2) do Activity.create(
               :user => gu,
               :action => :foo2,
               :subject => b1,
               :object => b2
             )
    end

    describe :add_to_list_with_score do
      it "should add the activity to the list" do
        activity.add_to_list_with_score(gu.stream_activities)
        gu.stream_activities.map(&:to_hash_without_time).should == [
          activity.to_hash_without_time
        ]

        activity.key[:containing_sorted_sets].smembers.should == [gu.stream_activities.key.to_s]
      end
    end


    describe :remove_from_list do
      it "should add the activity to the list" do
        activity.add_to_list_with_score(gu.stream_activities)
        activity.remove_from_list(gu.stream_activities)

        gu.stream_activities.map(&:to_hash_without_time).should == []
        activity.key[:containing_sorted_sets].smembers.should == []
      end
    end

    describe :remove_from_containing_lists do
      it "should remove the activity from the list" do
        activity.add_to_list_with_score(gu.stream_activities)
        activity.remove_from_containing_sorted_sets
        gu.stream_activities.all.should == []
      end

      it "should leave other activities intact" do

        activity.add_to_list_with_score(gu.stream_activities)
        activity2.add_to_list_with_score(gu.stream_activities)
        activity.remove_from_containing_sorted_sets
        gu.stream_activities.all.should == [activity2]

      end
    end
    describe :delete do
      it 'should call remove_from_containing_sorted_sets' do
        activity.should_receive(:remove_from_containing_sorted_sets)
        activity.delete
      end
    end
  end
end
