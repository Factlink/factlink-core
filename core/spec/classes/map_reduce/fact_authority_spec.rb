require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)
require File.expand_path('../../../../app/classes/map_reduce/fact_authority.rb', __FILE__)

describe MapReduce::FactAuthority do
  describe :wraped_map do
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
end
