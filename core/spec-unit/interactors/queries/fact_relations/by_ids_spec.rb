require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/by_ids.rb'

describe Queries::FactRelations::ByIds do
  include PavlovSupport

  before do
    stub_classes 'FactRelation', 'KillObject'
  end

  describe '.validate' do
    it 'requires each fact_relation_id to be an integer string' do
      expect_validating(['1', nil])
        .to fail_validation('fact_relation_id should be an integer string.')
    end
  end

  describe '#call' do
    it 'returns the dead fact_relation' do
      fact_relation = double(id: '1', class: 'FactRelation')
      dead_fact_relation = double
      graph_user = double
      opinion_on = double
      user = double(graph_user: graph_user)
      impact_opinion = double
      sub_comments_count = 2
      pavlov_options = { current_user: user }
      query = described_class.new [fact_relation.id], pavlov_options

      FactRelation.stub(:[])
                  .with(fact_relation.id)
                  .and_return(fact_relation)

      Pavlov.stub(:old_query)
            .with(:'sub_comments/count', fact_relation.id, fact_relation.class, pavlov_options)
            .and_return(sub_comments_count)
      Pavlov.stub(:old_query)
            .with(:'opinions/impact_opinion_for_fact_relation', fact_relation, pavlov_options)
            .and_return(impact_opinion)

      graph_user.stub(:opinion_on).with(fact_relation).and_return(opinion_on)
      KillObject.stub(:fact_relation)
                .with(fact_relation,
                      current_user_opinion: opinion_on,
                      impact_opinion: impact_opinion,
                      evidence_class: 'FactRelation')
                .and_return(dead_fact_relation)

      fact_relation.should_receive(:sub_comments_count=).with(sub_comments_count)

      expect(query.call).to eq [dead_fact_relation]
    end

    it 'works without a current user' do
      fact_relation = double(id: '1', class: 'FactRelation')
      dead_fact_relation = double
      opinion_on = double
      impact_opinion = double
      sub_comments_count = 2
      query = described_class.new [fact_relation.id]

      FactRelation.stub(:[])
                  .with(fact_relation.id)
                  .and_return(fact_relation)

      Pavlov.stub(:old_query)
            .with(:'sub_comments/count', fact_relation.id, fact_relation.class)
            .and_return(sub_comments_count)
      Pavlov.stub(:old_query)
            .with(:'opinions/impact_opinion_for_fact_relation', fact_relation)
            .and_return(impact_opinion)

      KillObject.stub(:fact_relation)
                .with(fact_relation,
                      current_user_opinion: nil,
                      impact_opinion: impact_opinion,
                      evidence_class: 'FactRelation')
                .and_return(dead_fact_relation)

      fact_relation.should_receive(:sub_comments_count=).with(sub_comments_count)

      expect(query.call).to eq [dead_fact_relation]
    end

    it 'raises when not found' do
      fact_relation_id = '1'
      query = described_class.new [fact_relation_id]

      FactRelation.stub(:[])
                  .with(fact_relation_id)
                  .and_return(nil)

      expect{query.call}.to raise_exception('FactRelation could not be found')
    end
  end
end
