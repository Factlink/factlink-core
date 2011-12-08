require_relative '../../ohm_helper.rb'
class Item < OurOhm;end

class TimeContainer < OurOhm
  timestamped_set :items, Item
end

describe Ohm::Model::TimestampedSet do
  
  let(:item1) { Item.create }
  
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
  
  describe "#until" do
    it "should return an empty list for an empty set" do
      c1 = TimeContainer.create
      c1.items << item1
      c1.items.until(Ohm::Model::TimestampedSet.current_time).should =~ [item1]
    end
  end
end