require 'pavlov_helper'
require_relative '../../../app/classes/map_reduce.rb'
require_relative '../../../app/classes/map_reduce/fact_authority.rb'

describe MapReduce::FactAuthority do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'FactRelation'
  end
  describe "#wrapped_map" do
    it do
      fact_relations = double ids: [1,2,3]

      fact_relation_db = {
        1 => stub(:FactRelation,
          from_fact_id: 10,
          created_by_id: 20,
        ),
        2 => stub(:FactRelation,
          from_fact_id: 10,
          created_by_id: 15,
        ),
        3 => stub(:FactRelation,
          from_fact_id: 12,
          created_by_id: 13,
        )
      }

      FactRelation.stub(:[]) { |id| fact_relation_db[id] }

      expect(subject.wrapped_map(fact_relations))
        .to eq({12 => [13], 10 => [20,15]})
    end
  end

  describe "#reduce" do
    it do
      fact = double :Fact,
            created_by_id: 3,
            opinionated_users_count: 100,
            channels: double(:Set, count: 40)

      Fact.stub(:[]).with(12)
          .and_return fact

      expect(subject.reduce(12, [20, 15])).to eq Math.log2(2) + 1
    end
  end
end
