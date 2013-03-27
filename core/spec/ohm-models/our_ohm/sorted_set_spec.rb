require 'spec_helper'

class Item < OurOhm;end
class SortedContainer < OurOhm
  sorted_set :items, Item do |x|
    1
  end
end


describe Ohm::Model::SortedSet do
  let(:c1) { SortedContainer.create }
  let(:c2) { SortedContainer.create }
  let(:c3) { SortedContainer.create }

  let(:i1) { Item.create }
  let(:i2) { Item.create }
  let(:i3) { Item.create }

  describe "union" do
    before do
      c1.items << i1
      c2.items << i2
      @union = c1.items | c2.items
    end

    it { c1.items.all.should =~ [i1] }
    it { c2.items.all.should =~ [i2] }
    it { @union.all.should =~ [i1,i2] }

    it do
      c3 = SortedContainer.create()
      @union.all.should =~ [i1,i2]
      c3.items = @union
      c3.items.all.should =~ [i1,i2]

      c3.items = c1.items
      c3.items.all.should =~ [i1]
    end
  end


  it "should have a working difference" do
    c1.items << i1 << i2
    c2.items << i1
    diff = c1.items - c2.items
    c1.items.all.should =~ [i1,i2]
    c2.items.all.should =~ [i1]
    diff.all.should =~ [i2]

    c1.items.delete(i2)
    diff = c1.items - c2.items
    c1.items.all.should =~ [i1]
    c2.items.all.should =~ [i1]
    diff.all.should =~ []
  end

  it "should have a working assignment" do
    c1.items << i1 << i2
    c2.items = c1.items
    c2.items.count.should == 2
    SortedContainer[c2.id].items.count.should == 2
  end

  describe "#below" do
    it "should return an empty list for an empty set" do
      c1.items.below(3).should =~ []
    end

    it "should return all items when no limit is given" do
      c1.items.add(i1,1)
      c1.items.add(i2,2)
      c1.items.below(3).should == [i1,i2]
    end

    it "should return only items below the limit" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.below(3).should == [i1]
    end

    it "should return only items below the limit (exclusive)" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.add(i3,3)
      c1.items.below(3).should == [i1]
    end

    it "should return all items when limit is infinity" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.add(i3,3)
      c1.items.below('inf').should == [i1,i3,i2]
    end

    it "should return a limitable set" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.add(i3,3)
      c1.items.below(5,count:2).should == [i3,i2]
    end

    it "should return from high to low when reversed is true" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.add(i3,3)
      c1.items.below(5,count:2,reversed:true).should == [i2,i3]
    end

    it "should return from low to high when reversed is false" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.add(i3,3)
      c1.items.below(5,count:2,reversed:false).should == [i3,i2]
    end

    it "should return items with scores when the withscores option is given" do
      c1.items.add(i1,1)
      c1.items.add(i2,4)
      c1.items.below(3,withscores:true).should == [{item:i1,score:1}]
    end
  end

  describe "#hash_array_for_withscores" do
    it "should work for an empty array" do
      c1.items.class.hash_array_for_withscores([]).should == []
    end
    it "should work for an array with one item with score" do
      c1.items.class.hash_array_for_withscores(['a',10]).should == [{score:10,item:'a'}]
    end
    it "should work for an array with scores which are strings" do
      c1.items.class.hash_array_for_withscores(['a','10']).should == [{score:10,item:'a'}]
    end
    it "should work for an array with multiple item with score" do
      c1.items.class.hash_array_for_withscores(['a',10,'b',5]).should == [{score:10,item:'a'},{score:5,item:'b'}]
    end
  end

end


