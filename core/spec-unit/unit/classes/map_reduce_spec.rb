require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)

describe MapReduce do
  describe :wrapped_reduce do
    it do
      subject.should_receive(:reduce).with(:a, [1,2]).and_return(3)
      subject.wrapped_reduce({a: [1,2]}).should == {:a=>3}
    end
  end
end
