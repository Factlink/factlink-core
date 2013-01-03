require 'pavlov'
describe Pavlov do
  describe "#string_to_classname" do
    it "should return the camel cased class" do
      expect(Pavlov.string_to_classname('foo')).to eq 'Foo'
    end
    it "should expand '/' to '::'" do
      expect(Pavlov.string_to_classname('foo/bar')).to eq 'Foo::Bar'
    end
  end
end
