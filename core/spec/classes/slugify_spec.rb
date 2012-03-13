require File.expand_path('../../../app/classes/slugify.rb', __FILE__)

class SluggifyTest
  include Slugify
end

describe SluggifyTest do
  {
    'foo' => 'foo',
    'Baas' => 'baas',
    "Foo BAR" => 'foo-bar'
  }.each_pair do |input, output|
    it {subject.slugify(input).should == output}
  end
end