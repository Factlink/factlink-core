require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/impact_opinion_for_fact_relation.rb'

describe Queries::Opinions::ImpactOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    it 'returns the dead opinion on the fact_relation' do
      dead_opinion = DeadOpinion.new(0.25, 0.75, 0.0, 4.0)
      believable = double(dead_opinion: dead_opinion)
      fact_relation = double(id: double, type: 'weakening', believable: believable)
      query = described_class.new fact_relation: fact_relation

      expect(query.call).to eq DeadOpinion.new(0, 1, 0, -2.0)
    end
  end

  describe '#validate' do
    it 'without fact_relation doesn\'t validate' do
      expect_validating(fact_relation: nil)
        .to fail_validation('fact_relation should not be nil.')
    end
  end
end
