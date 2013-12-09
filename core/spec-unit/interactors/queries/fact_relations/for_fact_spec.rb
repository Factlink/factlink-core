require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/for_fact.rb'

describe Queries::FactRelations::ForFact do
  include PavlovSupport

  before do
    stub_classes 'KillObject'
  end

  describe '#call' do
    it 'calls add_sub_comments_count_and_opinions_and_evidence_class for each fact_relation' do
      fact_relation = double(id: '1')
      dead_fact_relation = double
      fact = double
      type = :supporting

      query = described_class.new fact: fact, type: :supporting

      fact.stub(:evidence).with().and_return(double(ids: [fact_relation.id]))
      Pavlov.stub(:query)
            .with(:'fact_relations/by_ids',
                      fact_relation_ids: [fact_relation.id])
            .and_return([dead_fact_relation])

      result = query.call

      expect(result).to eq [dead_fact_relation]
    end
  end
end
