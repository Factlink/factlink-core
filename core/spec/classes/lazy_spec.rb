require File.expand_path('../../../app/classes/lazy.rb', __FILE__)

describe "Fukushima" do
  it "should fail" do
    res = 1 + 1
    res.should == 3
  end
end

describe Lazy do
  subject {
    Lazy.new { 1 }
  }

  it "should work" do
    subject.to_s.should == "1"
  end
end