require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/add_sub_comments_count_and_opinions_and_evidence_class.rb'

describe Queries::FactRelations::AddSubCommentsCountAndOpinionsAndEvidenceClass do
  include PavlovSupport

  before do
    stub_classes 'KillObject'
  end

  describe '.validate' do
    it 'requires fact_relation not to be nil' do
      expect_validating(nil).
        to fail_validation('fact_relation should not be nil.')
    end
  end

  describe '#call' do
    it 'returns a dead object' do
      fact_relation = double(id: '1', class: 'FactRelation')
      graph_user = double
      opinion_on = double
      user = double(graph_user: graph_user)
      impact_opinion = double
      dead_fact_relation = double
      sub_comments_count = 2
      pavlov_options = { current_user: user }

      query = described_class.new fact_relation, pavlov_options

      Pavlov.stub(:query)
            .with(:'sub_comments/count', fact_relation.id, fact_relation.class, pavlov_options)
            .and_return(sub_comments_count)
      Pavlov.stub(:query)
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

      expect(query.call).to eq dead_fact_relation
    end

    it 'works without a current user' do
      fact_relation = double(id: '1', class: 'FactRelation')
      graph_user = double
      opinion_on = double
      impact_opinion = double
      dead_fact_relation = double
      sub_comments_count = 2

      query = described_class.new fact_relation

      Pavlov.stub(:query)
            .with(:'sub_comments/count', fact_relation.id, fact_relation.class)
            .and_return(sub_comments_count)
      Pavlov.stub(:query)
            .with(:'opinions/impact_opinion_for_fact_relation', fact_relation)
            .and_return(impact_opinion)

      KillObject.stub(:fact_relation)
                .with(fact_relation,
                      current_user_opinion: nil,
                      impact_opinion: impact_opinion,
                      evidence_class: 'FactRelation')
                .and_return(dead_fact_relation)

      fact_relation.should_receive(:sub_comments_count=).with(sub_comments_count)

      expect(query.call).to eq dead_fact_relation
    end
  end
end
