require File.expand_path('../../../app/classes/map_reduce.rb', __FILE__)

class ExampleMapReduce < MapReduce
  def internal_map(iterator)
    iterator.each do |i|
      i.each_pair do |k,v|
        yield k, v*v
      end
    end
  end

  def internal_reduce(iterator, partial)
    iterator.each do |i|
      i.each_pair do |k, v|
         partial += v.inject(:+)
      end
    end
    yield iterator, partial
  end
end


describe ExampleMapReduce do
  it do
    list = [{a: 1}, {b: 2}, {c: 3}, {a: 4}]
    subject.map(list).should == {a: [1, 16], b: [4], c: [9]}
  end

  it do
    list = [{a: [1, 16], b: [4], c: [9]}]
    subject.reduce(list, 0).should == 30
  end

end
