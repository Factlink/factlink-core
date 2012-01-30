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
  end
end
