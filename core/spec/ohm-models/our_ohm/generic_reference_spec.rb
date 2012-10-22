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
      stub_const "Item", Class.new(OurOhm)
      @i = Item.create
      @g = GenTest.create
      @g.foo = @i
      @g.save
    end
    it {@g.foo.should == @i}
    it {GenTest[@g.id].foo.should == @i}
  end
  it do
    stub_const "ActiveModelObject", Class.new

    amo = ActiveModelObject.new
    amo.stub(id: "13")
    ActiveModelObject.should_receive(:find).with(amo.id).and_return(amo)

    gt = GenTest.new
    gt.foo = amo
    gt.save

    new_gt = GenTest[gt.id]
    new_gt.foo.should == amo
  end
end
