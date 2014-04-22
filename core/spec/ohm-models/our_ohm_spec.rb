require 'spec_helper'

class Item < OurOhm;end

class Container < OurOhm
  set :items, Item
end

describe OurOhm do
  subject { OurOhm.create }
  it "should do normal with collections" do
    class Root < OurOhm
      set :rootitems, Item
    end
    class A < Root
      set :aitems, Item
    end
    class B < Root
      set :bitems, Item
    end
    Root.collections.should =~ [:rootitems]
    A.collections.should =~ [:rootitems, :aitems]
    B.collections.should =~ [:rootitems, :bitems]
  end
  describe :to_param do
    it {subject.to_param.should == subject.id }
  end

end
