require File.expand_path('../../../app/classes/map_reduce.rb', __FILE__)

class ExampleMapReduce < MapReduce
  def map iterator
    iterator.each do |i|
      i.each_pair do |k,v|
        yield k, v*v
      end
    end
  end

  def reduce bucket, partials
      partials.inject(:+)
  end
end


describe ExampleMapReduce do
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
    subject.map_reduce(list).should == {:a=>17, :b=>4, :c=>9}
  end
end

describe MapReduce do
  describe :wrapped_reduce do
    it do
      subject.should_receive(:reduce).with(:a, [1,2]).and_return(3)
      subject.wrapped_reduce({a: [1,2]}).should == {:a=>3}
    end
  end
end
