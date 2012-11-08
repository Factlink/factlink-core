require File.expand_path('../../../app/classes/lazy.rb', __FILE__)

describe Lazy do
  subject { 
    Lazy.new { 1 }
  }

  it "should work" do
    subject.to_s.should == "1"
  end
end