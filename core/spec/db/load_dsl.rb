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
  
  it "creating one channel with another channel as subchannel, and redefining the second channel should only create two channels" do
    subject.run do
      user "merijn", "merijn@example.com", "123hoi"
      user "mark", "mark@example.com", "123hoi"
    
      user "merijn"
        channel "foo"
          sub_channel "mark", "bar"
    
      user "mark"
        channel "bar"
    end
    Channel.all.size.should == 2
  end

end