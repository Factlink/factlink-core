require 'spec_helper'

describe User do
  it "should be able to create a job" do
    @j = Job.create
    @j.new?.should == false
  end
  it "should be able to create a job with attributes" do
    @j = Job.create title: 'foo', content: 'bar', show: true
    @j.new?.should == false
    @j.title.should == 'foo'
    @j.content.should == 'bar'
    @j.show.should be_true
  end
end