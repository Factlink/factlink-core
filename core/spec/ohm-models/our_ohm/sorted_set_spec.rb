require_relative '../../ohm_helper.rb'
class Item < OurOhm;end
class SortedContainer < OurOhm
  sorted_set :items, Item do |x|
    1
  end
end


describe Ohm::Model::SortedSet do
  describe "union" do
    before do
      @c1 = SortedContainer.create()
      @c2 = SortedContainer.create()
      @a = Item.create()
      @b = Item.create()
      @c1.items << @a
      @c2.items << @b
      @union = @c1.items | @c2.items
    
    end
    it { @c1.items.all.should =~ [@a] }
    it { @c2.items.all.should =~ [@b] }
    it { @union.all.should =~ [@a,@b] }
    it do
      @c3 = SortedContainer.create()
      @union.all.should =~ [@a,@b]
      @c3.items = @union
      @c3.items.all.should =~ [@a,@b]
      
      @c3.items = @c1.items
      @c3.items.all.should =~ [@a]
    end
  end 
  
  
  it "should have a working difference" do
    c1 = SortedContainer.create()
    c2 = SortedContainer.create()
    a = Item.create()
    b = Item.create()
    c1.items << a << b
    c2.items << a
    diff = c1.items - c2.items
    c1.items.all.should =~ [a,b]
    c2.items.all.should =~ [a]
    diff.all.should =~ [b]
    
    c1.items.delete(b)
    diff = c1.items - c2.items
    c1.items.all.should =~ [a]
    c2.items.all.should =~ [a]
    diff.all.should =~ []
  end

  it "should have a working assignment" do
    c1 = SortedContainer.create()
    c2 = SortedContainer.create()
    c1.items << Item.create << Item.create
    c2.items = c1.items
    c2.items.count.should == 2
    SortedContainer[c2.id].items.count.should == 2
  end
  
end


