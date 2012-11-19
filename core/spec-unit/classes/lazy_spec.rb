require_relative '../../app/classes/lazy.rb'

describe Lazy do
  subject {
    Lazy.new { 1 }
  }

  it "should work" do
    subject.to_s.should == "1"
  end
end
