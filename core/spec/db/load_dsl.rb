require 'spec_helper'
require File.expand_path('../../../db/load_dsl.rb', __FILE__)

describe LoadDsl do
  it "should add one channel when adding the same channel twice" do
    subject.user "merijn", "merijn@gmail.com", "123hoi"
    subject.channel "hoi"
    subject.channel "hoi"
    Channel.all.size.should == 2 + 2
  end
  
  it "should error when a user is made without passoword" do
      expect { subject.user "merijn" }.to raise_error(UndefinedUserError)
  end

  it "should error when a user is made without passoword" do
      expect { subject.fact "hoi" }.to raise_error(UndefinedUserError)
  end
  
  it "creating one channel with another channel as subchannel, and redefining the second channel should only create two channels" do
    subject.run do
      user "merijn", "merijn@example.com", "123hoi", "merijn481"
      user "merijn", "merijn@example.com", "123hoi", "merijn481"
      user "mark", "mark@example.com", "123hoi", "markijbema"
    
      user "merijn"
        channel "foo"
          sub_channel "mark", "bar"
    
      user "mark"
        channel "bar"
    end
    Channel.all.size.should == 2+2+2
  end

  it "should work" do
    subject.run do
      user "merijn", "merijn@gmail.com", "123hoi", "merijn481"
      user "tom", "tom@codigy.nl", "123hoi", "tomdev"
      user "jordin", "jordin@factlink.com", "123hoi", "vanzwoljj"
      user "remon", "remon@factlink.com", "123hoi", "R51"
      user "salvador", "salvador@factlink.com", "123hoi", "salvadorven"
      user "mark", "mark@factlink.com", "123hoi", "markijbema"
      user "joel", "joel@factlink.com", "123hoi", "joelkuiper"
      user "luit", "luit@factlink.com", "123hoi", "LuitvD"


      user "tom"
        fact "foo"
    end
  end

end