require 'spec_helper'

class Blob < OurOhm ;end
class Foo < OurOhm
  timestamped_set :activities, Activity
end

describe Activity::Listener do
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }
  let(:b1)  { Blob.create }
  let(:b2)  { Blob.create }
  let(:f1)  { Foo.create }
  let(:f2)  { Foo.create }

  after :all do
    create_activity_listeners
  end

  before do
    Activity.any_instance.stub(:after_create)
  end

  describe :new do
    it "should call its dsl with the block if there is a block" do
      block = proc { puts "hoi" }
      Activity::Listener::Dsl.should_receive(:new)
      Activity::Listener.new &block
    end
    it "should not call the dsl when no block is provided" do
      Activity::Listener::Dsl.should_not_receive(:new)
      Activity::Listener.new
    end
  end

  describe :add_to do
    before do
      subject.activity_for = Blob
      subject.listname = 'foo'

      @a = Activity.create subject: b1, object: f1, action: :foobar
    end
    it "should return no result when no queries are defined" do
      subject.add_to(@a).should == []
    end
    it "should return the id of the blob and list to which to add if a query matches" do
      subject.queries << {subject: Blob, write_ids: lambda {|a| [1,2,3]}}
      subject.stub(matches: true)
      subject.add_to(@a).should == [1,2,3]
    end
  end

  describe :matches do
    before do
      subject.activity_for = Blob
      subject.listname = 'foo'

      @a = Activity.create subject: b1, object: f1, action: :foobar
    end
    it "should not match for an empty query" do
      subject.matches({}, @a).should be_false
      subject.matches({baron: 0b100}, @a).should be_false
    end
    it "should match if a property is the same" do
      subject.matches({subject_class: Blob },@a).should be_true
      subject.matches({object_class: Foo },@a).should be_true
      subject.matches({action: :foobar},@a).should be_true
    end
    it "should not match if a property is different" do
      subject.matches({subject_class: Foo },@a).should be_false
      subject.matches({object_class: Blob },@a).should be_false
      subject.matches({action: :barfoo},@a).should be_false
    end
    it "should match if a property is in a list" do
      subject.matches({action: [:foobar, :jigglypuff]},@a).should be_true
    end
    it "should not match if a property is not in a list" do
      subject.matches({action: [:barfoo, :humbug, :dizzly]},@a).should be_false
    end
    it "should execute the extra_condition query to see if the activity matches" do
      subject.matches({
        subject_class: Blob,
        extra_condition: lambda { |a| a.action.to_s == 'foobar' }
        },@a).should be_true
      subject.matches({subject_class: Blob, extra_condition: lambda {|a| a.action.to_s == 'barfoo'} },@a).should be_false
    end
  end

  describe :process do
    it "should add the activities to a timestamped set on the object" do
      subject.activity_for = 'Foo'
      subject.listname = :activities
      subject.queries << {subject_class: Foo, write_ids: lambda { |a| [f1.id] } }

      a1 = Activity.create subject: f1, object: f1, action: :foobar
      subject.process a1
      f1.activities.ids.should =~ [a1.id]
      f2.activities.ids.should =~ []
    end
    it "should pass the activity to the write_ids" do
      subject.activity_for = 'Foo'
      subject.listname = :activities
      subject.queries << {subject_class: Foo, write_ids: lambda { |a| [a.subject.id] } }

      a1 = Activity.create subject: f1, object: f1, action: :foobar
      subject.process a1
      f1.activities.ids.should =~ [a1.id]
      f2.activities.ids.should =~ []

    end
  end

  describe ".register" do
    it "should contain the registered query in the .all" do
      Activity::Listener.reset
      Activity::Listener.register do
        activity_for "Foo"
        named :bar
      end
      Activity::Listener.all.length.should == 1
      Activity::Listener.all.first[1].activity_for.should == "Foo"
      Activity::Listener.all.first[1].listname.should == :bar
    end
  end

  describe "attributes" do
    it do
      subject.activity_for = "hoi"
      subject.activity_for.should == "hoi"
    end
    it do
      subject.listname = "doei"
      subject.listname.should == "doei"
    end
  end

end
