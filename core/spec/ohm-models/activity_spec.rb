require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/activity.rb'

class Blob < OurOhm ;end
class Foo < OurOhm ;end
class GraphUser < OurOhm ;end

describe Activity do
  before do
    @b1 = Blob.create
    @b2 = Blob.create
    @gu = GraphUser.create
  end

  context "initially" do
    describe ".for" do
      it "should be empty" do
        Activity.for(@b1).to_a.should =~ []
        Activity.for(@b2).to_a.should =~ []
        Activity.for(@gu).to_a.should =~ []
      end
    end
  end

  context "after creating one activity" do
    before do
      a = Activity.create(
             :user => @gu,
             :action => :foo,
             :subject => @b1,
             :object => @b2
           )
      @activity = Activity[a.id]
    end
    it {@activity.user.should == @gu }
    it {@activity.subject.should == @b1 }
    it {@activity.object.should == @b2 }
    describe "should be retrievable with Activity.for" do
      it {Activity.for(@gu).to_a.should =~ [@activity] }
      it "should give no results for an object without activities" do
        Activity.for(Foo.create).to_a.should =~ []
      end
      it {Activity.for(@b1).to_a.should =~ [@activity] }
      it {Activity.for(@b2).to_a.should =~ [@activity] }
    end
  end

  context "when dealing with activities on graphusers" do
    before do
      @gu2 = GraphUser.create
      @gu3 = GraphUser.create
      a = Activity.create(
             :user => @gu,
             :action => :foo,
             :subject => @gu2,
             :object => @gu3
           )
      @activity = Activity[a.id]
    end
    it {@activity.user.should == @gu }
    it {@activity.subject.should == @gu2 }
    it {@activity.object.should == @gu3 }
    describe "should be retrievable with Activity.for" do
      it {Activity.for(@gu).to_a.should =~ [@activity] }
      it "should give no results for an object without activities" do
        Activity.for(Foo.create).to_a.should =~ []
      end
      it {Activity.for(@gu2).to_a.should =~ [@activity] }
      it {Activity.for(@gu3).to_a.should =~ [@activity] }
    end
  end

end