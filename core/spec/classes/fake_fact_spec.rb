require "spec_helper"

describe FakeFact do
  it "is possible to create one" do
    f = FakeFact.new([100, 3, 50], [], "banna")
    f.interactions.below(10).should == []
  end

  it "is possible to create one" do
    f = FakeFact.new([100, 3, 50], [['remon','http://foo']], "banna")
    f.interactions.below(10).length.should == 1

    f.interacting_users.should be_nil

    f.interactions.below(10)[0].user.user.username.should == 'remon'
    f.interactions.below(10).uniq().take(3)[0].user.user.username.should == 'remon'
  end
end
