require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/by_ids.rb'

describe Queries::FactRelations::ByIds do
  include PavlovSupport

  before do
    stub_classes 'FactRelation', 'KillObject'
    stub_const 'ActionController::RoutingError', Class.new(StandardError)
  end

  describe '.validate' do
    it 'requires each fact_relation_id to be an integer string' do
      expect_validating(fact_relation_ids: ['1', nil])
        .to fail_validation('fact_relation_id should be an integer string.')
    end
  end

  describe '#call' do
    it 'returns the dead fact_relation' do
      believable = double
      fact_relation = double(id: '1', class: 'FactRelation', believable: believable)
      dead_fact_relation = double
      graph_user = double
      user = double(graph_user: graph_user)
      votes = double
      sub_comments_count = 2
      query = described_class.new fact_relation_ids: [fact_relation.id]

      FactRelation.stub(:[])
                  .with(fact_relation.id)
                  .and_return(fact_relation)

      Pavlov.stub(:query)
            .with(:'sub_comments/count',
                      parent_id: fact_relation.id, parent_class: fact_relation.class)
            .and_return(sub_comments_count)
      Pavlov.stub(:query)
            .with(:'believable/votes', believable: believable)
            .and_return(votes)

      KillObject.stub(:fact_relation)
                .with(fact_relation,
                      votes: votes,
                      evidence_class: 'FactRelation')
                .and_return(dead_fact_relation)

      fact_relation.should_receive(:sub_comments_count=).with(sub_comments_count)

      expect(query.call).to eq [dead_fact_relation]
    end

    it 'raises when not found' do
      fact_relation_id = '1'
      query = described_class.new fact_relation_ids: [fact_relation_id]

      FactRelation.stub(:[])
                  .with(fact_relation_id)
                  .and_return(nil)

      expect { query.call }.to raise_error(ActionController::RoutingError,
        'FactRelation could not be found')
    end
  end
end
