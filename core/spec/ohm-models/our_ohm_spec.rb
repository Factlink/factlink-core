require_relative '../ohm_helper.rb'

class Item < OurOhm
end

class Container < OurOhm
  set :items, Item
  sorted_set :sorted_items, Item do |x|
    1
  end
end

class TimeContainer < OurOhm
  timestamped_set :items, Item
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
  
end

describe Ohm::Model::SortedSet do
  describe "union" do
    before do
      @c1 = Container.create()
      @c2 = Container.create()
      @a = Item.create()
      @b = Item.create()
      @c1.sorted_items << @a
      @c2.sorted_items << @b
      @union = @c1.sorted_items | @c2.sorted_items
    
    end
    it { @c1.sorted_items.all.should =~ [@a] }
    it { @c2.sorted_items.all.should =~ [@b] }
    it { @union.all.should =~ [@a,@b] }
    it do
      @c3 = Container.create()
      @union.all.should =~ [@a,@b]
      @c3.sorted_items = @union
      @c3.sorted_items.all.should =~ [@a,@b]
      
      @c3.sorted_items = @c1.sorted_items
      @c3.sorted_items.all.should =~ [@a]
    end
  end 
  
  
  it "should have a working difference" do
    c1 = Container.create()
    c2 = Container.create()
    a = Item.create()
    b = Item.create()
    c1.sorted_items << a << b
    c2.sorted_items << a
    diff = c1.sorted_items - c2.sorted_items
    c1.sorted_items.all.should =~ [a,b]
    c2.sorted_items.all.should =~ [a]
    diff.all.should =~ [b]
    
    c1.sorted_items.delete(b)
    diff = c1.sorted_items - c2.sorted_items
    c1.sorted_items.all.should =~ [a]
    c2.sorted_items.all.should =~ [a]
    diff.all.should =~ []
  end
end

describe Ohm::Model::TimestampedSet do
  it "should have an unread count of 0 when marked as unread" do
    c1 = TimeContainer.create()
    c1.items.unread_count.should == 0
    
    c1.items << Item.create
    c1.items.unread_count.should == 1
    
    # Prevent race condition
    sleep(0.01)
    c1.items.mark_as_read
    c1.items.unread_count.should == 0
    c1.items << Item.create
    c1.items << Item.create
    c1.items.unread_count.should == 2
  end
  
  it "should have a working assignment" do
    c1 = TimeContainer.create()
    c2 = TimeContainer.create()
    c1.items << Item.create << Item.create
    c2.items = c1.items
    c2.items.count.should == 2
    TimeContainer[c2.id].items.count.should == 2
  end
end

describe OurOhm do
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
end


class GenTest < Ohm::Model
  extend OhmGenericReference
  generic_reference :foo
end

describe OhmGenericReference do
  context "initially" do
    it {GenTest.new.foo.should == nil}
    it {GenTest.create.foo.should == nil}
  end
  context "after adding an item" do
    before do
      @i = Item.create
      @g = GenTest.create
      @g.foo = @i
      @g.save
    end
    it {@g.foo.should == @i}
    it {GenTest[@g.id].foo.should == @i}
  end
end