require 'spec_helper'

class Item < OurOhm;end

class Container < OurOhm
  set :items, Item
end

describe Ohm::Model::Set do
  before do
    @c1 = Container.create()
    @c2 = Container.create()
    @a = Item.create()
    @b = Item.create()
    @c1.items << @a
    @c2.items << @b
  end
  it "should have a working union" do
    union = @c1.items | @c2.items
    @c1.items.all.should =~ [@a]
    @c2.items.all.should =~ [@b]
    union.all.should =~ [@a,@b]
  end

  it "should be able to return the list of ids" do
    @c1.items << @b
    @c1.items.ids.should =~ [@a.id,@b.id]
  end

  describe :make_empty do
    it "should remove all elements" do
      @c1.items << @b
      @c1.items.make_empty
      @c1.items.ids.should =~ []
    end

  end

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
