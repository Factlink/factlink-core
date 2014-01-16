require 'spec_helper'

describe LoadDsl do
  it "should error when a user is made without password" do
      expect { subject.fact "hoi" }.to raise_error(LoadDsl::UndefinedUserError)
  end

  it "should add beliefs" do
    subject.run do
      user "merijn", "merijn@gmail.com", "123hoi", "Merijn Terheggen"
      user "tomdev", "tom@factlink.com", "123hoi", "Tom de Vries"
      user "mark", "mark@example.com", "123hoi"

      as_user "mark"
        fact "something is true", "http://example.org/" do
          believers "merijn","tomdev"
          disbelievers "mark"
        end
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
