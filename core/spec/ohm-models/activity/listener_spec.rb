require 'spec_helper'

describe Activity::Listener do
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }
  let(:b1)  { Blob.create }
  let(:b2)  { Blob.create }
  let(:f1)  { Foo.create }
  let(:f2)  { Foo.create }

  before do
    stub_const 'Blob', Class.new(OurOhm)
    stub_const 'Foo', Class.new(OurOhm)
    class Foo
      timestamped_set :activities, Activity
    end
    stub_const 'Interactors::SendMailForActivity', double
  end

  after :all do
    Activity::ListenerCreator.new.create_activity_listeners
  end


  def send_mail_for_activity_should_be_invoked
    Pavlov.should_receive(:old_interactor)
      .with(:send_mail_for_activity, an_instance_of(Activity), { current_user: true })
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

      send_mail_for_activity_should_be_invoked

      @a = Activity.create subject: b1, object: f1, action: :foobar
    end

    it "should return no result when no queries are defined" do
      expect(subject.add_to(@a)).to eq []
    end

    it "should return the id of the blob and list to which to add if a query matches" do
      subject.queries << {subject: Blob, write_ids: ->(a) { [1,2,3]}}
      subject.stub(matches: true)
      expect(subject.add_to(@a)).to eq [1,2,3]
    end
  end

  describe '#matches_any?' do
    before do
      send_mail_for_activity_should_be_invoked
    end

    it "should return no result when no queries are defined" do
      listener = Activity::Listener.new do
        activity_for "Blob"
        named :foo
      end

      activity = Activity.create subject: Blob.create, action: :foobar
      expect(listener.matches_any?(activity)).to eq false
    end

    it "should return the id of the blob and list to which to add if a query matches" do
      listener = Activity::Listener.new do
        activity_for "Blob"
        named :foo

        activity subject_class: "Blob",
                 action: :foobar
      end

      activity = Activity.create subject: Blob.create, action: :foobar
      expect(listener.matches_any?(activity)).to eq true
    end

    it "should return false when the query doesn't match" do
      listener = Activity::Listener.new do
        activity_for "Blob"
        named :foo

        activity subject_class: "Bar",
                 action: :foobar
      end

      activity = Activity.create subject: Blob.create, action: :foobar
      expect(listener.matches_any?(activity)).to eq false
    end
  end


  describe :matches do
    before do
      subject.activity_for = Blob
      subject.listname = 'foo'

      send_mail_for_activity_should_be_invoked

      @a = Activity.create subject: b1, object: f1, action: :foobar
    end

    it "should not match for an empty query" do
      expect(subject.matches({}, @a)).to be_false
    end

    it "should match if a property is the same" do
      expect(subject.matches({subject_class: Blob },@a)).to be_true
      expect(subject.matches({object_class: Foo },@a)).to be_true
      expect(subject.matches({action: :foobar},@a)).to be_true
    end

    it "should not match if a property is different" do
      expect(subject.matches({subject_class: Foo },@a)).to be_false
      expect(subject.matches({object_class: Blob },@a)).to be_false
      expect(subject.matches({action: :barfoo},@a)).to be_false
    end

    it "should match if a property is in a list" do
      expect(subject.matches({action: [:foobar, :jigglypuff]},@a)).to be_true
    end

    it "should not match if a property is not in a list" do
      expect(subject.matches({action: [:barfoo, :humbug, :dizzly]},@a)).to be_false
    end

    it "should execute the extra_condition query to see if the activity matches" do
      expect(subject.matches({
        subject_class: Blob,
        extra_condition: ->(a) { a.action.to_s == 'foobar' }
      },@a)).to be_true
      expect(subject.matches({
        subject_class: Blob,
        extra_condition: ->(a) { a.action.to_s == 'barfoo'}
      },@a)).to be_false
    end
  end

  describe :process do
    before do
      send_mail_for_activity_should_be_invoked
    end

    it "should add the activities to a timestamped set on the object" do
      subject.activity_for = 'Foo'
      subject.listname = :activities
      subject.queries << {subject_class: Foo, write_ids: ->(a) { [f1.id] } }

      a1 = Activity.create subject: f1, object: f1, action: :foobar
      subject.process a1
      expect(f1.activities.ids).to match_array [a1.id]
      expect(f2.activities.ids).to match_array []
    end

    it "should pass the activity to the write_ids" do
      subject.activity_for = 'Foo'
      subject.listname = :activities
      subject.queries << {subject_class: Foo, write_ids: ->(a) { [a.subject.id] } }

      a1 = Activity.create subject: f1, object: f1, action: :foobar
      subject.process a1
      expect(f1.activities.ids).to match_array [a1.id]
      expect(f2.activities.ids).to match_array []

    end
  end

  describe ".register" do
    it "should contain the registered query in the .all" do
      Activity::Listener.reset
      Activity::Listener.register do
        activity_for "Foo"
        named :bar
      end
      expect(Activity::Listener.all.length).to eq 1
      expect(Activity::Listener.all.first[1].length).to eq 1
      expect(Activity::Listener.all.first[1][0].activity_for).to eq "Foo"
      expect(Activity::Listener.all.first[1][0].listname).to eq :bar
    end
  end

  describe "attributes" do
    it do
      subject.activity_for = "hoi"
      expect(subject.activity_for).to eq "hoi"
    end

    it do
      subject.listname = "doei"
      expect(subject.listname).to eq "doei"
    end
  end

end
