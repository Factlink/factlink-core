require File.expand_path('../../../app/classes/fake_fact.rb', __FILE__)
require 'hashie'
require 'date'
describe FakeFact do
  it "should be possible to create one" do
    f = FakeFact.new({believes: 100, disbelieves: 3, doubts: 50}, [], "banna")
    f.interactions.below(10).should == []
  end
  it "should be possible to create one" do
    f = FakeFact.new({believes: 100, disbelieves: 3, doubts: 50}, [['remon','http://foo']], "banna")
    f.interactions.below(10).length.should == 1
    f.interactions.below(10)[0].user.username.should == 'remon'
  end
end