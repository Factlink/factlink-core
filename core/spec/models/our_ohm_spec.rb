require 'spec_helper'

class Item < Ohm::Model
end

class Container < Ohm::Model
  set :items, Item
end


    

describe Ohm::Model::Set do
  it "should have a working union" do
    c1 = Container.create()
    c2 = Container.create()
    a = Item.create()
    b = Item.create()
    c1.items << a
    c2.items << b
    union = c1.items | c2.items
    c1.items.all.should =~ [a]
    c2.items.all.should =~ [b]
    union.all.should =~ [a,b]
    puts c1
    puts c2
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