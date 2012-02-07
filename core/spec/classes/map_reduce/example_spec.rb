require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)
require File.expand_path('../../../../app/classes/map_reduce/example.rb', __FILE__)

describe MapReduce::Example do
  subject do
    MapReduce::Example.new do|k,v|
      @res ||= {}
      @res[k] = v
    end
  end

  it do
    list = [{a: 1}, {b: 2}, {c: 3}, {a: 4}]
    subject.wrapped_map(list).should == {a: [1, 16], b: [4], c: [9]}
  end

  it do
    list = {a: [1, 16], b: [4], c: [9]}
    subject.wrapped_reduce(list).should == {:a=>17, :b=>4, :c=>9}
  end

  it do
    list = [{a: 1}, {b: 2}, {c: 3}, {a: 4}]
    subject.map_reduce(list)
    @res.should == {:a=>17, :b=>4, :c=>9}
  end
end
