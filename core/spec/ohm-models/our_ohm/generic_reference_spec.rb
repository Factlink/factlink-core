require_relative '../../ohm_helper.rb'

class GenTest < Ohm::Model
  extend OurOhm::GenericReference
  generic_reference :foo
end

describe OurOhm::GenericReference do
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