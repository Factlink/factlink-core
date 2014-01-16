require 'spec_helper'

describe LoadDsl do
  it "should add beliefs" do
    subject.run do
      user "merijn", "merijn@gmail.com", "123hoi", "Merijn Terheggen"
      user "tomdev", "tom@factlink.com", "123hoi", "Tom de Vries"
      user "mark", "mark@example.com", "123hoi", "Mark IJbema"

      as_user "mark" do
        fact "something is true", "http://example.org/" do
          believers "merijn","tomdev"
          disbelievers "mark"
        end
      end
    end # shouldn't raise
  end

  it "should throw an error if a user with a non-unique email is added" do
    expect do
      subject.run do
        user "tom", "tom@codigy.nl", "123hoi", "Mark IJbema"
        user "tomdev", "tom@codigy.nl", "123hoi", "Tom de Vries"
      end
    end.to raise_error
  end

end
