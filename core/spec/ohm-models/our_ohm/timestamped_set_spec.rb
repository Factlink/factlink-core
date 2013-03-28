require 'spec_helper'

class Item < OurOhm;end

class TimeContainer < OurOhm
  timestamped_set :items, Item
end

describe Ohm::Model::TimestampedSet do
  let(:c1) { TimeContainer.create }
  let(:c2) { TimeContainer.create }

  let(:item1) { Item.create }
  let(:item2) { Item.create }
  let(:item3) { Item.create }

  it "should have an unread count of 0 when marked as unread" do
    c1.items.unread_count.should == 0

    c1.items << item1
    c1.items.unread_count.should == 1

    # Prevent race condition
    sleep(0.01)
    c1.items.mark_as_read
    c1.items.unread_count.should == 0
    c1.items << item2
    c1.items << item3
    c1.items.unread_count.should == 2
  end
end
