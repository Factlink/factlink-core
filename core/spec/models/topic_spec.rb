require'spec_helper'

describe Topic do
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

  describe 'by_channel' do
    it "should not crash when channel.slug_title is nil" do
      ch = double(Channel)
      ch.stub(:title).and_return('<EVIL>')
      ch.stub(:slug_title).and_return(nil)
      Topic.get_or_create_by_channel(ch)
    end
  end

  describe '.redis' do
    it 'is new_topic' do
      expect(Topic.redis).to eq 'new_topic'
    end
  end
end
