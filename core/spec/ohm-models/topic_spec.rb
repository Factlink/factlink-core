require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/topic.rb'

class Channel < OurOhm
end


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
      t2.should be_new
    end
    it "should not be able to create multiple topics with the a similar name" do
      t1 = Topic.create title: "Foo"
      t2 = Topic.create title: 'foo'
      t2.should be_new
    end
  end

  describe 'by_slug' do
    ['foo'].each do
    it "should return the object by its slug" do
         t1 = Topic.create title: "foo"
         Topic.by_title("foo").should == t1
      end
    end
  end
end
