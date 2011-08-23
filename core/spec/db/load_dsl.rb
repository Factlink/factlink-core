require 'spec_helper'
require File.expand_path('../../../db/load_dsl.rb', __FILE__)

describe LoadDsl do
  it "should add one channel when adding the same channel twice" do
    subject.user "merijn", "merijn@gmail.com", "123hoi"
    subject.channel "hoi"
    subject.channel "hoi"
    Channel.all.size.should == 1
  end
  
  it "should error when a user is made without passoword" do
      expect { subject.user "merijn" }.to raise_error(UndefinedUserError)
  end

  it "should error when a user is made without passoword" do
      expect { subject.fact "hoi" }.to raise_error(UndefinedUserError)
  end

end