require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/by_id.rb'

describe Queries::FactRelations::ById do
  include PavlovSupport

  before do
    stub_classes 'FactRelation'
  end

  describe '.validate' do
    it 'requires fact_relation_id to be an integer' do
      expect_validating(nil).
        to fail_validation('fact_relation_id should be an integer string.')
    end
  end

  describe '#call' do
    it 'returns the dead fact_relation' do
      fact_relation_id = '1'
      fact_relation = double
      dead_fact_relation = double
      query = described_class.new fact_relation_id

      FactRelation.stub(:[])
                  .with(fact_relation_id)
                  .and_return(fact_relation)

      Pavlov.stub(:query)
            .with(:'fact_relations/add_sub_comments_count_and_opinions_and_evidence_class', fact_relation)
            .and_return(dead_fact_relation)

      expect(query.call).to eq dead_fact_relation
    end

    it 'raises when not found' do
      fact_relation_id = '1'
      query = described_class.new fact_relation_id

      FactRelation.stub(:[])
                  .with(fact_relation_id)
                  .and_return(nil)

      expect{query.call}.to raise_exception('FactRelation could not be found')
    end
  end
end
