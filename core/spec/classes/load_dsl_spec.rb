require 'spec_helper'

describe LoadDsl do
  let(:default_channels_length) { 1 }

  it "should add one channel when adding the same channel twice" do
    subject.user "merijn", "merijn@gmail.com", "123hoi"
    subject.channel "hoi"
    subject.channel "hoi"
    Channel.all.size.should == default_channels_length + 1
  end

  it "should error when a user is made without password" do
      expect { subject.user "merijn" }.to raise_error(LoadDsl::UndefinedUserError)
  end

  it "should error when a user is made without password" do
      expect { subject.fact "hoi" }.to raise_error(LoadDsl::UndefinedUserError)
  end

  it "creating one channel with another channel as subchannel, and redefining the second channel should only create two channels" do
    subject.run do
      user "merijn", "merijn@example.com", "123hoi"
      user "merijn", "merijn@example.com", "123hoi"
      user "mark", "mark@example.com", "123hoi"

      user "merijn"
        channel "foo"
          sub_channel "mark", "bar"

      user "mark"
        channel "bar"
    end
    Channel.all.size.should == default_channels_length + 2 + # channels defined in user "merijn"
                               default_channels_length + 0   # cahnnels defined in user "mark"
  end

  it "should add beliefs" do
    subject.run do
      user "merijn", "merijn@gmail.com", "123hoi", "Merijn", "Terheggen"
      user "tomdev", "tom@factlink.com", "123hoi", "Tom", "de Vries"
      user "mark", "mark@example.com", "123hoi"

      user "mark"
        fact "something is true", "http://example.org/"
          believers "merijn","tomdev"
          disbelievers "mark"
    end # shouldn't raise
  end

  it "should throw an error if a user with a non-unique email is added" do
    expect do
      subject.run do
        user "tom", "tom@codigy.nl", "123hoi"
        user "tomdev", "tom@codigy.nl", "123hoi"
      end
    end.to raise_error
  end

end
