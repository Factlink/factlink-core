require_relative '../../../app/classes/map_reduce.rb'
require_relative '../../../app/classes/map_reduce/fact_authority.rb'



describe MapReduce::FactAuthority do
  before do
    unless defined?(Fact)
      class Fact;end
    end
  end
  describe :wrapped_map do
    it do
      factrelations = [
        stub(:FactRelation,
          from_fact_id: 10,
          created_by_id: 20,
        ),
        stub(:FactRelation,
          from_fact_id: 10,
          created_by_id: 15,
        ),
        stub(:FactRelation,
          from_fact_id: 12,
          created_by_id: 13,
        )
      ]
      subject.wrapped_map(factrelations).should == {12 => [13], 10 => [20,15]}
    end
  end

  describe :reduce do
    it do
      Fact.should_receive(:[]).with(12).and_return(stub(:Fact,
        created_by_id: 3,
        opinionated_users_count: 100,
        channels: stub(:Set, count: 40)
      ))
      subject.reduce(12, [20, 15]).should == Math.log2(2) + 1
    end
  end
end
