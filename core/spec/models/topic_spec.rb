require'spec_helper'

describe Topic do

  describe ".by_title" do
    it "should return a new object when no topic with the title exists" do
      Topic.by_title("idontexist").should be_a(Topic)
      Topic.by_title("idontexist").title.should == "idontexist"
   end
    it "should return the topic with given title if the title exists" do
      t1 = Topic.create title: "foo"
      Topic.by_title("foo").should == t1
    end
    it "should return a topic with a similar title if the topic already existed" do
      t1 = Topic.create title: "foo"
      Topic.by_title("Foo").should == t1
    end
  end

  describe "create" do
    it "should not be able to create multiple topics with the same name" do
      t1 = Topic.create title: "foo"
      t2 = Topic.create title: t1.title
      t2.should be_new_record
    end
    it "should not be able to create multiple topics with the a similar name" do
      t1 = Topic.create title: "Foo"
      t2 = Topic.create title: 'foo'
      t2.should be_new_record
    end
  end

  describe 'by_slug' do
    ['foo'].each do |title|
      it "should return the object by its slug" do
         t1 = Topic.create title: title
         Topic.by_slug(title.to_url).should == t1
      end
    end
  end
  describe 'by_channel' do
    it "should not crash when channel.slug_title is nil" do
      ch = mock(Channel)
      ch.stub!(:title).and_return('<EVIL>')
      ch.stub!(:slug_title).and_return(nil)
      Topic.for_channel(ch)
    end
  end

  describe "channel_for_user" do
    let(:u) { create :user }
    let(:ch) { create :channel, created_by: u.graph_user }

    it "should return a channel belonging to the user and topic" do
      ch.topic.channel_for_user(u).should == ch
    end
  end


  describe 'top_users' do
    let(:u) {create :user}
    it "should be possible to add a top user" do
      subject.top_users_add u, 3
      subject.top_users.should == [u]
    end
    it "should be possible to clear the top users" do
      subject.top_users_add u, 3
      subject.top_users_clear
      subject.top_users.should == []
    end
  end

end
