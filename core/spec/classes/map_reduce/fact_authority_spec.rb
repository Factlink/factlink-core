require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)
require File.expand_path('../../../../app/classes/map_reduce/fact_authority.rb', __FILE__)

unless defined?(Fact)
  class Fact
  end
end


describe MapReduce::FactAuthority do
  describe :wrapped_map do
    it do
      factrelations = [
        stub(:FactRelation,
          fact_id: 10,
          created_by_id: 20,
        ),
        stub(:FactRelation,
          fact_id: 10,
          created_by_id: 15,
        ),
        stub(:FactRelation,
          fact_id: 12,
          created_by_id: 13,
        )
      ]
      subject.wrapped_map(factrelations).should == {12 => [13], 10 => [20,15]}
    end
  end

  describe :reduce do
    it do
      Fact.should_receive(:[]).with(12).and_return(stub(:Fact, created_by_id: 3))
      subject.reduce 12, [20, 15]
    end
  end
end
