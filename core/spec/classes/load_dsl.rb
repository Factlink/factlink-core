require 'spec_helper'

describe LoadDsl do
  it "should add one channel when adding the same channel twice" do
    subject.user "merijn", "merijn@gmail.com", "123hoi"
    subject.channel "hoi"
    subject.channel "hoi"
    Channel.all.size.should == 2 + 2
  end
  
  it "should error when a user is made without passoword" do
      expect { subject.user "merijn" }.to raise_error(LoadDsl::UndefinedUserError)
  end

  it "should error when a user is made without passoword" do
      expect { subject.fact "hoi" }.to raise_error(LoadDsl::UndefinedUserError)
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

  it "should throw an error if a user with a non-unique email is added" do
    expect do
      subject.run do
        user "tom", "tom@codigy.nl", "123hoi", "tomdev"
        user "tomdev", "tom@codigy.nl", "123hoi", "tomdev"
      end
    end.to raise_error
  end

end